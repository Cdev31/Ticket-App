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
}
