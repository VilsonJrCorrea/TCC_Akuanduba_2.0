import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.nio.file.Path;

public class Main {

    public static void main(String[] args) {
        String nomeRoot = "conf";
        String nomeSubPasta = "local";
        String nomePreArquivo = "eis";

        File dir = new File(nomeRoot + File.separator + nomeSubPasta);
        System.out.println(dir.getAbsolutePath());
        if (!dir.exists()) {
            dir.mkdirs();
        }
        String scenario = "city2018";
        String host = "localhost";
        int port = 12300;
        boolean scheduling = false;
        int timeout = 40000;
        boolean times = false;
        boolean notifications = false;
        boolean queued = false;
        String preConnection = "connection";
        String preUserName = "akuanduba_distribuido2_";
        String password = "kF5pLs";
        boolean iilang = false;
        boolean xml = false;

        for (int i = 0; i < 34; i++) {
            String nameCompleto = preConnection + "A" + (i + 1);
            String userNameCompleto = preUserName + (i + 1);
            Entiti entiti = new Entiti(nameCompleto, userNameCompleto, password, iilang, xml);
            Entiti[] entitis = {entiti};
            Config config = new Config(scenario, host, port, scheduling, timeout, times, notifications, queued, entitis);
            try (Writer writer = new FileWriter(dir + File.separator + nomePreArquivo + i + ".json")) {
                Gson gson = new GsonBuilder().create();
                gson.toJson(config, writer);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }


    }
}
