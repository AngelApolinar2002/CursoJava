public class CunetaBancaria {
    private double saldo;

    public void depositar (double monto){
        saldo += monto;
    }

    public double getSaldo(){
        return saldo;
    }
}
