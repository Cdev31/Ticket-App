package com.tikets.model;

public class ClientModel {

    private String Id;
    private String firstname;
    private String lastname;
    private WorkModel necessaryWork;

    public ClientModel(String _id, String _firstname, String _lastname, WorkModel _necessaryWork) {
        Id = _id;
        firstname = _firstname;
        lastname = _lastname;
        necessaryWork = _necessaryWork;
    }

    public String getId() {
        return Id;
    }

    public String getFirstname() {
        return firstname;
    }

    public String getLastname() {
        return lastname;
    }

    public WorkModel getNecessaryWork() {
        return necessaryWork;
    }

    public void setFirstname(String firstname) {
        this.firstname = firstname;
    }

    public void setLastname(String lastname) {
        this.lastname = lastname;
    }

    public void setNecessaryWork(WorkModel necessaryWork) {
        this.necessaryWork = necessaryWork;
    }
}
