import model.Time;
import util.Calculos;
import util.File;
import util.UpdateTime;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class Main {

    private static final String timeA = "A";
    private static final String timeB = "B";
    private static final String jobCompleted = "Job completed by ";

    public static void main(String[] args) {
        int contSimulacoes = File.contSimulacoes();
        List<String> conteudo = File.getDadosPartidas(contSimulacoes);

        Time objTimeA = new Time(timeA, contSimulacoes);
        Time objTimeB = new Time(timeB, contSimulacoes);

        for (String linha : conteudo) {
            if (linha.contains(jobCompleted)) {
                if (linha.contains(jobCompleted + timeA)) {
                    UpdateTime.changeObj(objTimeA, linha);
                }
                if (linha.contains(jobCompleted + timeB)) {
                    UpdateTime.changeObj(objTimeB, linha);
                }
            }

        }
        objTimeA = UpdateTime.setMediaEDp(objTimeA);
        objTimeB = UpdateTime.setMediaEDp(objTimeB);
        System.out.println(objTimeA.toString());
        System.out.println(objTimeB.toString());
    }

}
