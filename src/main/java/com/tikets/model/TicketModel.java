package com.tikets.model;

import java.time.LocalDate;
import java.time.LocalTime;
import com.tikets.utils.*;

public class TicketModel {

    private String Id;
    private TicketState state;
    private WorkModel typeWork;
    private LocalDate createdDay;
    private LocalTime createdHour;
    private LocalDate startDate;
    private LocalDate endDate;
    private String comments;

    public TicketModel(String _id, TicketState _state, WorkModel _typeWork, LocalDate _createdDay,
            LocalTime _createdHour, LocalDate _startDate, LocalDate _endDate, String _comments) {
        Id = _id;
        state = _state;
        typeWork = _typeWork;
        createdDay = _createdDay;
        createdHour = _createdHour;
        startDate = _startDate;
        endDate = _endDate;
        comments = _comments;
    }

    public String getId() {
        return Id;
    }

    public TicketState getState() {
        return state;
    }

    public WorkModel getTypeWork() {
        return typeWork;
    }

    public LocalDate getCreatedDay() {
        return createdDay;
    }

    public LocalTime getCreatedHour() {
        return createdHour;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public String getComments() {
        return comments;
    }

    public void setState(TicketState state) {
        this.state = state;
    }

    public void setTypeWork(WorkModel typeWork) {
        this.typeWork = typeWork;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }
}
