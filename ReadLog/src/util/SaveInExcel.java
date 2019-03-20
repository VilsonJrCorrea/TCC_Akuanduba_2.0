package util;

import com.sun.media.sound.InvalidFormatException;
import model.Partida;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;

public class SaveInExcel {

    private static String[] columns = {
            "Partida",
            "Seed",
            "JobComum",
            "Mission",
            "AuctionJob",
            "Equipe",
            "SomatMassium",
            "JobComumAtendido",
            "MissionAtendido",
            "AuctionJobAtendido",
            "ProporcaoJob",
            "ProporcaoMission",
            "Equipe",
            "SomatMassium",
            "JobComumAtendido",
            "MissionAtendido",
            "AuctionJobAtendido",
            "ProporcaoJob",
            "ProporcaoMission"
    };


    public static void save(List<Partida> partidas) throws IOException, InvalidFormatException {
        Workbook workbook = new HSSFWorkbook();// new HSSFWorkbook() for generating `.xls` file
        CreationHelper createHelper = workbook.getCreationHelper();

        Sheet sheet = workbook.createSheet("Partidas");

        Font headerFont = workbook.createFont();
        headerFont.setFontHeightInPoints((short) 12);
        headerFont.setColor(IndexedColors.RED.getIndex());


        // Create a Row
        Row headerRow = sheet.createRow(0);

        // Create cells
        for (int i = 0; i < columns.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(columns[i]);
        }
        int rowNum = 1;
        for (Partida partida : partidas) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(partida.getId());
            row.createCell(1).setCellValue(partida.getSemente());
            row.createCell(2).setCellValue(partida.getQtdJobComum());
            row.createCell(3).setCellValue(partida.getQtdMission());
            row.createCell(4).setCellValue(partida.getQtdAuctionJob());
            row.createCell(5).setCellValue(partida.getTimeA().getNome());
            row.createCell(6).setCellValue(partida.getTimeA().getSomatorioMassium());
            row.createCell(7).setCellValue(partida.getTimeA().getQtdJobComumAtendido());
            row.createCell(8).setCellValue(partida.getTimeA().getQtdMissionAtendido());
            row.createCell(9).setCellValue(partida.getTimeA().getQtdAuctionJobAtendido());
            row.createCell(10).setCellValue(partida.getTimeA().getProporcaoJob());
            row.createCell(11).setCellValue(partida.getTimeA().getProporcaoMission());
            row.createCell(12).setCellValue(partida.getTimeB().getNome());
            row.createCell(13).setCellValue(partida.getTimeB().getSomatorioMassium());
            row.createCell(14).setCellValue(partida.getTimeB().getQtdJobComumAtendido());
            row.createCell(15).setCellValue(partida.getTimeB().getQtdMissionAtendido());
            row.createCell(16).setCellValue(partida.getTimeB().getQtdAuctionJobAtendido());
            row.createCell(17).setCellValue(partida.getTimeB().getProporcaoJob());
            row.createCell(18).setCellValue(partida.getTimeB().getProporcaoMission());
        }

        for (int i = 0; i < columns.length; i++) {
            sheet.autoSizeColumn(i);
        }

        FileOutputStream fileOut = new FileOutputStream(partidas.get(0).getId() + ".xls");
        workbook.write(fileOut);
        fileOut.close();
    }
}

