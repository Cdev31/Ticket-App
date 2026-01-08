package com.tikets.model;

public class HistoryModel {

    private String Id;
    private UserModel inCharge;
    private TicketModel ticketBelonging;
    private ClientModel client;
    private String changes;

    public HistoryModel(String _id, UserModel _inCharge, TicketModel _ticketBelonging, ClientModel _client,
            String _changes) {
        Id = _id;
        inCharge = _inCharge;
        ticketBelonging = _ticketBelonging;
        client = _client;
        changes = _changes;
    }

    public String getId() {
        return Id;
    }

    public UserModel getInCharge() {
        return inCharge;
    }

    public TicketModel getTicketBelonging() {
        return ticketBelonging;
    }

    public ClientModel getClient() {
        return client;
    }

    public String getChanges() {
        return changes;
    }

    public void setInCharge(UserModel inCharge) {
        this.inCharge = inCharge;
    }

    public void setTicketBelonging(TicketModel ticketBelonging) {
        this.ticketBelonging = ticketBelonging;
    }

    public void setClient(ClientModel client) {
        this.client = client;
    }

    public void setChanges(String changes) {
        this.changes = changes;
    }
}
