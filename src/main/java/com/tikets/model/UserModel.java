package com.tikets.model;

public class UserModel {

    private String Id;
    private String firstname;
    private String lastname;
    private int age;
    private boolean isActive;

    public UserModel(String _id, String _firstname, String _lastname, int _age, boolean _isActive) {
        Id = _id;
        firstname = _firstname;
        lastname = _lastname;
        age = _age;
        isActive = _isActive;
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

    public int getAge() {
        return age;
    }

    public boolean getIsActive() {
        return isActive;
    }

    public void setFirstname(String firstname) {
        this.firstname = firstname;
    }

    public void setLastname(String lastname) {
        this.lastname = lastname;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }
}
