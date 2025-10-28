package com.example.btl.service;

import com.example.btl.dao.OrderDAO;
import com.example.btl.dao.OrderItemDAO;
import com.example.btl.model.Order;
import com.example.btl.model.OrderItem;
import com.example.btl.model.OrderStatus;

import java.util.List;

public class OrderService {
    private final OrderDAO orderDAO;
    private final OrderItemDAO orderItemDAO;

    public OrderService(OrderDAO orderDAO, OrderItemDAO orderItemDAO) {
        this.orderDAO = orderDAO;
        this.orderItemDAO = orderItemDAO;
    }

    public Order get(int id) { return orderDAO.getById(id); }
    public List<Order> listByUser(int userId) { return orderDAO.listByUser(userId); }
    public boolean create(Order order) { return orderDAO.create(order); }
    public boolean updateStatus(int orderId, OrderStatus status) { return orderDAO.updateStatus(orderId, status); }

    public List<OrderItem> items(int orderId) { return orderItemDAO.listByOrder(orderId); }
    public boolean addItem(OrderItem item) { return orderItemDAO.create(item); }
}

