package santander.novaplax.model;

import java.math.BigDecimal;
import java.util.Date;

public class ReporteVenta {
    private int ticketId;
    private Date fecha;
    private String clienteNombre;
    private String vendedor;
    private BigDecimal total;
    private int cantidadArticulos;

    public int getTicketId() { return ticketId; }
    public void setTicketId(int ticketId) { this.ticketId = ticketId; }
    
    public Date getFecha() { return fecha; }
    public void setFecha(Date fecha) { this.fecha = fecha; }
    
    public String getClienteNombre() { return clienteNombre; }
    public void setClienteNombre(String clienteNombre) { this.clienteNombre = clienteNombre; }
    
    public String getVendedor() { return vendedor; }
    public void setVendedor(String vendedor) { this.vendedor = vendedor; }
    
    public BigDecimal getTotal() { return total; }
    public void setTotal(BigDecimal total) { this.total = total; }
    
    public int getCantidadArticulos() { return cantidadArticulos; }
    public void setCantidadArticulos(int cantidadArticulos) { this.cantidadArticulos = cantidadArticulos; }
    
    // Método para obtener subtotal formateado (opcional)
    public String getTotalFormateado() {
        return String.format("S/%.2f", total);
    }
}