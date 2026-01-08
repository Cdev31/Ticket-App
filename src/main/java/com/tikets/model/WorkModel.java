package com.tikets.model;

public class WorkModel {

    private String Id;
    private String title;
    private String description;

    public WorkModel(String _id, String _title, String _description) {
        Id = _id;
        title = _title;
        description = _description;
    }

    public String getId() {
        return Id;
    }

    public String getTitle() {
        return title;
    }

    public String getDescription() {
        return description;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setDescription(String description) {
        this.description = description;
    }

}
