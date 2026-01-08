package com.tikets.config;

import io.github.cdimascio.dotenv.Dotenv;

public class ConfigEnv {

    private Dotenv dotenv;
    private String host;
    private String port;
    private String db;
    private String user;
    private String password;

    public ConfigEnv() {
        Dotenv dotenv = Dotenv.load();
        host = dotenv.get("DB_HOST");
        port = dotenv.get("");
        db = dotenv.get("");
        user = dotenv.get("");
        password = dotenv.get("");
    }

    public String getHost() {
        return host;
    }

    public String getPort() {
        return port;
    }

    public String getDb() {
        return db;
    }

    public String getUser() {
        return user;
    }

    public String getPassword() {
        return password;
    }
}