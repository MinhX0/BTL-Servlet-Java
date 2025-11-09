package com.example.btl.service;

import java.time.Instant;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public class ChatStore {
    public static class Msg {
        public final String from; public final String to; public final String content; public final long ts;
        public final boolean fromSeller;
        public Msg(String from, String to, String content, boolean fromSeller) {
            this.from = from; this.to = to; this.content = content; this.fromSeller = fromSeller; this.ts = Instant.now().toEpochMilli();
        }
    }
    // active customers tracking
    private static final Set<String> activeCustomers = ConcurrentHashMap.newKeySet();
    // in-memory per-customer queues (recent 100)
    private static final Map<String, Deque<Msg>> queues = new ConcurrentHashMap<>();

    public static void customerOnline(String username){ activeCustomers.add(username); queues.computeIfAbsent(username, k-> new ArrayDeque<>());}
    public static void customerOffline(String username){ activeCustomers.remove(username);}
    public static Set<String> getActiveCustomers(){ return activeCustomers; }

    public static void sendToCustomer(String username, Msg msg){
        Deque<Msg> q = queues.computeIfAbsent(username, k-> new ArrayDeque<>());
        q.addLast(msg);
        while(q.size()>100) q.pollFirst();
    }
    public static List<Msg> pollForCustomer(String username, long afterTs){
        Deque<Msg> q = queues.computeIfAbsent(username, k-> new ArrayDeque<>());
        List<Msg> out = new ArrayList<>();
        for(Msg m: q){ if (m.ts > afterTs) out.add(m);} return out;
    }
}
