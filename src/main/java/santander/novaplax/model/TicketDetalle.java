package santander.novaplax.model;

import java.math.BigDecimal;

public class TicketDetalle {
    private int id;
    private int ticketId;
    private int articuloId;
    private String articuloNombre;
    private int cantidad;
    private BigDecimal precioUnitario;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getTicketId() { return ticketId; }
    public void setTicketId(int ticketId) { this.ticketId = ticketId; }
    public int getArticuloId() { return articuloId; }
    public void setArticuloId(int articuloId) { this.articuloId = articuloId; }
    public String getArticuloNombre() { return articuloNombre; }
    public void setArticuloNombre(String articuloNombre) { this.articuloNombre = articuloNombre; }
    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }
    public BigDecimal getPrecioUnitario() { return precioUnitario; }
    public void setPrecioUnitario(BigDecimal precioUnitario) { this.precioUnitario = precioUnitario; }
    public BigDecimal getSubtotal() { return precioUnitario.multiply(new BigDecimal(cantidad)); }
}