package com.example.btl.web;

import com.example.btl.web.i18n.Utf8Control;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.jsp.jstl.core.Config;
import jakarta.servlet.jsp.jstl.fmt.LocalizationContext;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Locale;
import java.util.ResourceBundle;

public class LocaleFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(true);

        // Force UTF-8 for request/response I/O
        if (req.getCharacterEncoding() == null) {
            req.setCharacterEncoding(StandardCharsets.UTF_8.name());
        }
        res.setCharacterEncoding(StandardCharsets.UTF_8.name());

        // Allow ?lang=vi or ?lang=en to switch locale
        String lang = req.getParameter("lang");
        if (lang != null && !lang.isBlank()) {
            Locale newLocale = switch (lang.toLowerCase()) {
                case "vi", "vi_vn" -> Locale.forLanguageTag("vi-VN");
                default -> Locale.ENGLISH;
            };
            session.setAttribute("appLocale", newLocale);
        }
        // Default locale if not set
        Locale locale = (Locale) session.getAttribute("appLocale");
        if (locale == null) {
            locale = Locale.ENGLISH;
            session.setAttribute("appLocale", locale);
        }
        // Load UTF-8 bundle and configure JSTL
        ResourceBundle bundle = ResourceBundle.getBundle("messages", locale, new Utf8Control());
        LocalizationContext lc = new LocalizationContext(bundle, locale);
        Config.set(req, Config.FMT_LOCALE, locale);
        Config.set(req, Config.FMT_FALLBACK_LOCALE, Locale.ENGLISH);
        Config.set(req, Config.FMT_LOCALIZATION_CONTEXT, lc);

        chain.doFilter(request, response);
    }
}
