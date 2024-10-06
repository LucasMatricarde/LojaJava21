package lucasmatricar.com.lojajava.model;

import jakarta.persistence.*;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.Objects;

@Entity
@Table(name = "cupom_desconto")
@SequenceGenerator(name = "seq_cupom_desconto", sequenceName = "seq_cupom_desconto", allocationSize = 1)
public class CupomDesconto implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_cupom_desconto")
    private Long id;

    private String codigoDesc;

    private BigDecimal valorRealDesc;

    private BigDecimal valorPorcentagemDesc;

    @Temporal(TemporalType.DATE)
    private Date dataValidade;

    public void setId(Long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }

    public String getCodigoDesc() {
        return codigoDesc;
    }

    public void setCodigoDesc(String codigoDesc) {
        this.codigoDesc = codigoDesc;
    }

    public BigDecimal getValorRealDesc() {
        return valorRealDesc;
    }

    public void setValorRealDesc(BigDecimal valorRealDesc) {
        this.valorRealDesc = valorRealDesc;
    }

    public BigDecimal getValorPorcentagemDesc() {
        return valorPorcentagemDesc;
    }

    public void setValorPorcentagemDesc(BigDecimal valorPorcentagemDesc) {
        this.valorPorcentagemDesc = valorPorcentagemDesc;
    }

    public Date getDataValidade() {
        return dataValidade;
    }

    public void setDataValidade(Date dataValidade) {
        this.dataValidade = dataValidade;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        CupomDesconto that = (CupomDesconto) o;
        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(id);
    }
}
