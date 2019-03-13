package util;

import java.util.List;

public class Calculos {
    public static double[] getMediaComDP(double score, int n) {
        double media = score / n;
        double somatorioDesvioPadrao = 0;
        double sub = score - media;
        double pot = Math.pow(sub, 2);
        somatorioDesvioPadrao = somatorioDesvioPadrao + pot;
        double desvioPadrao = somatorioDesvioPadrao / (n - 1);
        desvioPadrao = Math.sqrt(desvioPadrao);
        double resposta[] = {media, desvioPadrao};
        return resposta;
    }
}
