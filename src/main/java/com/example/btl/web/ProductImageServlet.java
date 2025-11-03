package com.example.btl.web;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebServlet(name = "ProductImageServlet", urlPatterns = {"/product-image"})
public class ProductImageServlet extends HttpServlet {
    private String baseDir;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        ServletContext ctx = config.getServletContext();
        this.baseDir = ctx.getInitParameter("productImageBaseDir");
        if (this.baseDir == null || this.baseDir.isBlank()) {
            this.baseDir = "C:/product/image"; // default fallback
        }
        ctx.log("[ProductImageServlet] Base dir = " + this.baseDir);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        ServletContext ctx = getServletContext();
        String name = req.getParameter("file");
        if (name != null) {
            name = URLDecoder.decode(name, StandardCharsets.UTF_8);
            name = name.trim();
            // normalize slashes and strip accidental query/hash appended to file param
            name = name.replace('\\', '/');
            int q = name.indexOf('?');
            if (q >= 0) name = name.substring(0, q);
            int h = name.indexOf('#');
            if (h >= 0) name = name.substring(0, h);
        }
        boolean debug = "1".equals(req.getParameter("debug")) || "true".equalsIgnoreCase(req.getParameter("debug"));
        ctx.log("[ProductImageServlet] Incoming file param='" + name + "' debug=" + debug);

        if (name == null || name.isBlank()) {
            if (debug) {
                resp.setContentType("text/plain;charset=UTF-8");
                try (PrintWriter pw = resp.getWriter()) {
                    pw.println("ProductImageServlet DEBUG");
                    pw.println("BaseDir=" + baseDir);
                    pw.println("Incoming file param is empty");
                    pw.flush();
                }
                return;
            }
            streamPlaceholder(resp);
            return;
        }

        Path base = Paths.get(baseDir).toAbsolutePath().normalize();
        Path requested = Paths.get(name).normalize();
        // If absolute path provided (e.g., "/image.png" or "C:\\..."), fall back to just the file name for safety
        if (requested.isAbsolute()) {
            Path fileName = requested.getFileName();
            if (fileName == null) {
                if (debug) {
                    resp.setContentType("text/plain;charset=UTF-8");
                    try (PrintWriter pw = resp.getWriter()) {
                        pw.println("ProductImageServlet DEBUG");
                        pw.println("BaseDir=" + baseDir);
                        pw.println("Normalized name had no fileName: " + name);
                    }
                    return;
                }
                streamPlaceholder(resp);
                return;
            }
            ctx.log("[ProductImageServlet] Absolute path provided; using file name: " + fileName);
            requested = fileName;
        }
        Path filePath = base.resolve(requested).normalize();
        boolean underBase = filePath.startsWith(base);
        File file = filePath.toFile();
        boolean exists = file.exists() && file.isFile();

        if (debug) {
            resp.setContentType("text/plain;charset=UTF-8");
            try (PrintWriter pw = resp.getWriter()) {
                pw.println("ProductImageServlet DEBUG");
                pw.println("BaseDir=" + baseDir);
                pw.println("IncomingFileParam=" + name);
                pw.println("ResolvedPath=" + filePath);
                pw.println("UnderBaseDir=" + underBase);
                pw.println("Exists=" + exists);
                pw.flush();
            }
            return;
        }

        if (!underBase) {
            ctx.log("[ProductImageServlet] Path traversal detected: " + filePath);
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (!exists) {
            ctx.log("[ProductImageServlet] File not found: " + filePath);
            streamPlaceholder(resp);
            return;
        }

        // Add helpful headers for debugging in DevTools
        resp.setHeader("X-Product-Image-BaseDir", base.toString());
        resp.setHeader("X-Product-Image-ResolvedPath", filePath.toString());
        resp.setHeader("X-Product-Image-Exists", String.valueOf(exists));

        String mime = Files.probeContentType(filePath);
        if (mime == null) mime = "application/octet-stream";
        resp.setContentType(mime);
        resp.setHeader("Cache-Control", "public, max-age=86400");
        resp.setDateHeader("Last-Modified", file.lastModified());
        resp.setContentLengthLong(file.length());

        try (InputStream in = new BufferedInputStream(new FileInputStream(file));
             OutputStream out = resp.getOutputStream()) {
            in.transferTo(out);
        }
    }

    private void streamPlaceholder(HttpServletResponse resp) throws IOException {
        ServletContext ctx = getServletContext();
        String placeholderPath = "/assets/img/placeholder.jpg";
        try (InputStream in = ctx.getResourceAsStream(placeholderPath)) {
            if (in == null) {
                ctx.log("[ProductImageServlet] Placeholder missing at " + placeholderPath);
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            resp.setContentType("image/jpeg");
            resp.setHeader("Cache-Control", "public, max-age=3600");
            try (OutputStream out = resp.getOutputStream()) {
                in.transferTo(out);
            }
        }
    }
}
