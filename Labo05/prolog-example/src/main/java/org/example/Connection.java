package org.example;

import alice.tuprolog.Prolog;
import alice.tuprolog.SolveInfo;
import alice.tuprolog.Struct;
import alice.tuprolog.Term;
import alice.tuprolog.Theory;

import java.io.InputStream;

public class Connection {

    private final Prolog engine = new Prolog();

    public Connection() throws Exception {
        try (InputStream in = getClass().getResourceAsStream("/calculo.pl")) {
            if (in == null) throw new IllegalStateException("No se encontró calculo.pl");
            engine.setTheory(new Theory(in));
        }
    }

    public String consultar(String predicado, String expresion) throws Exception {
        SolveInfo info = engine.solve(predicado + "(x, " + expresion + ", R).");
        return info.isSuccess() ? formatear(info.getTerm("R"), 0)
                : "Sin solución para esa expresión";
    }

    // ------------------------------------------------------------------
    // Formato legible: 6*x^2 en vez de '*'(6,'^'(x,2))
    // ------------------------------------------------------------------
    private static int prioridad(String op) {
        switch (op) {
            case "+":
            case "-": return 1;
            case "*":
            case "/": return 2;
            case "^": return 3;
            default:  return 0;
        }
    }

    private static String formatear(Term t, int contexto) {
        t = t.getTerm(); // desenvuelve variables ya resueltas
        if (!(t instanceof Struct)) {
            return t.toString();
        }
        Struct s = (Struct) t;
        String nombre = s.getName();
        int aridad = s.getArity();

        if (aridad == 0) {
            return nombre;
        }
        if (aridad == 2 && prioridad(nombre) > 0) {
            int p = prioridad(nombre);
            boolean derecha = nombre.equals("^");
            String izq = formatear(s.getArg(0), derecha ? p + 1 : p);
            String der = formatear(s.getArg(1), derecha ? p : p + 1);
            String r = izq + nombre + der;
            return p < contexto ? "(" + r + ")" : r;
        }
        if (aridad == 1 && nombre.equals("-")) {
            String r = "-" + formatear(s.getArg(0), 3);
            return 2 < contexto ? "(" + r + ")" : r;
        }
        StringBuilder sb = new StringBuilder(nombre).append("(");
        for (int i = 0; i < aridad; i++) {
            if (i > 0) sb.append(",");
            sb.append(formatear(s.getArg(i), 0));
        }
        return sb.append(")").toString();
    }
}