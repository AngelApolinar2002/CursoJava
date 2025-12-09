//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
public class Main {
    public static void main(String[] args) {
        Persona p = new Persona("Oscar", 25);

        p.saludar();

        CunetaBancaria cuenta = new CunetaBancaria();
        cuenta.depositar(1500);

        System.out.println("Saldo " + cuenta.getSaldo());

        Animal a1 = new Gato();
        Animal a2 = new Perro();

        //POLIMOSFIRMO
        // CREAMOS OBJETOS DE TIPO ANIMAL PERO QUE REALMENTE SON GATO Y PERRO
        // ESTO DEMUESTRA QUE EL POLIMOSFIRMO: UN MISMO TIPO (ANIMAL) SE COMPORTA DISTINT0
        // SEGUN EL OBJETO QUE REPRESENTA
        a1.hacersonido();
        a2.hacersonido();

        // usamos el metodo estatico sumar de la clase util
        System.out.printf("Suma " + Util.sumar(5, 7));

        //IMPRIMIMOS LA CONSTATE PI DEFINIDA EN LA CLASE UTIL
        // LAS CONSTATES FINALES NO SE PUEDEN CAMBIAR SU VALOR
        System.out.println("Valor de PI: " + Util.PI);
        System.out.println(Util.msgGen);

    }
}

    //  4152 3139 1187 7087