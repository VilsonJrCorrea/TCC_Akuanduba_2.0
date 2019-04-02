package util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReadFiles {
    private static final int QUANTIDADE_ROUND = 5;
    //    private static final String nomeArquivo = "paris1.log";
    private static final String fimDaPartida = "Simulation at step 999";
    private static FileReader ler = null;
    private static BufferedReader reader;


    public static Map<String, List<String>> getDadosPartidas() {
//    public static void main(String[] args) {
        Map<String, List<String>> conteudoDosLogs = new HashMap<>();
        File files = new File("./logs");
        File listaArquivos[] = files.listFiles();
        String map = "";
        for (File file : listaArquivos) {
            List<String> conteudo = new ArrayList<String>();
            String linha = "";
            int auxContSimulacoes = 0;
            try {
                ler = new FileReader(file.getAbsoluteFile());
                reader = new BufferedReader(ler);
                while ((linha = reader.readLine()) != null) {
                    conteudo.add(linha);
                    if (linha.contains(fimDaPartida)) {
                        auxContSimulacoes++;
                        if (auxContSimulacoes == QUANTIDADE_ROUND) {
                            break;
                        }
                    }
                    if (linha.contains("Configuring scenario map")) {
                        map = linha.split(": ", 0)[1];
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            if (conteudoDosLogs.containsKey(map)) {
                List<String> aux = conteudoDosLogs.get(map);
                aux.addAll(conteudo);
            } else {
                conteudoDosLogs.put(map, conteudo);
            }
        }

        return conteudoDosLogs;

    }
}
