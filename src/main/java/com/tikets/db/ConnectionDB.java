package com.tikets.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import com.tikets.config.ConfigEnv;

public class ConnectionDB {

    ConfigEnv config;

    ConnectionDB() {
        config = new ConfigEnv();
    }

    public static void main(String[] args) {
        String url = "";
        try (Connection connection = DriverManager.getConnection(url, config.getUser(), config.getPassword())) {
            System.out.println("Coneccion exitosa");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
