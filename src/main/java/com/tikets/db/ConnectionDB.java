package com.tikets.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionDB {
    public static void main(String[] args) {
        String user = "", password = "", url = "";
        try (Connection connection = DriverManager.getConnection(url, user, password)) {
            System.out.println("Coneccion exitosa");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
