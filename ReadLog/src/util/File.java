package util;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class File {
    private static final String nomeArquivo = "MASSim-log-2019-03-12-14-33-47.log";
    private static final String fimDaPartida = "Simulation at step 999";
    private static FileReader ler = null;
    private static BufferedReader reader;

    public static int contSimulacoes() {
        int contSimulacoes = 0;
        try {
            ler = new FileReader(nomeArquivo);
            reader = new BufferedReader(ler);
            String linha;
            while ((linha = reader.readLine()) != null) {
                if (linha.contains(fimDaPartida)) {
                    contSimulacoes++;
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return contSimulacoes;
    }

    public static List<String> getDadosPartidas(int contSimulacoes) {
        List<String> conteudo = new ArrayList<>();
        String linha = "";
        int auxContSimulacoes = 0;
        try {
            ler = new FileReader(nomeArquivo);
            reader = new BufferedReader(ler);
            while ((linha = reader.readLine()) != null) {
                conteudo.add(linha);
                if (linha.contains(fimDaPartida)) {
                    auxContSimulacoes++;
                    if (auxContSimulacoes == contSimulacoes) {
                        break;
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return conteudo;
    }
}