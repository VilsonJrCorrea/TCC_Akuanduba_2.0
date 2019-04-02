package mapc2018udesc;


import java.io.File;

import jacamo.infra.JaCaMoLauncher;
import jason.JasonException;
public class RunExperimento {

	public static void main(String args[]) {
		try {
			JaCaMoLauncher.main
			(new String[] { "mapc2018experimento.jcm" 					});
		} catch (JasonException e) {
			System.out.println("Exception: "+e.getMessage());
			e.printStackTrace();
		}

	}
}
