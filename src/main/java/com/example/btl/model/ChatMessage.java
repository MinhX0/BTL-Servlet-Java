package com.example.btl.model;

import java.time.LocalDateTime;

public class ChatMessage {
    private String from;
    private String to; // optional, null means broadcast to support
    private String content;
    private LocalDateTime sentAt = LocalDateTime.now();
    private boolean fromSeller;

    public ChatMessage() {}
    public ChatMessage(String from, String to, String content, boolean fromSeller) {
        this.from = from;
        this.to = to;
        this.content = content;
        this.fromSeller = fromSeller;
    }

    public String getFrom() { return from; }
    public void setFrom(String from) { this.from = from; }
    public String getTo() { return to; }
    public void setTo(String to) { this.to = to; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public LocalDateTime getSentAt() { return sentAt; }
    public void setSentAt(LocalDateTime sentAt) { this.sentAt = sentAt; }
    public boolean isFromSeller() { return fromSeller; }
    public void setFromSeller(boolean fromSeller) { this.fromSeller = fromSeller; }
}
