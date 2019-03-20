package calculos;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import jason.stdlib.substring;

public class Calculos {

	private Ponto maisAcima;
	private Ponto maisAbaixo;
	private Ponto maisEsquerda;
	private Ponto maisDireita;
	private Ponto pontoMedio;
	private List<Reta> retasPoligono = new ArrayList<>();
	private List<Ponto> pontosNaoCalculados = new ArrayList<>();
	private String tipoInstalacao;
	private double bordas[];

	public Calculos(String tipoInstalacao, List<Ponto> listaPontos) {
		super();
		this.tipoInstalacao = tipoInstalacao;
		this.pontosNaoCalculados = listaPontos;
	}

	public List<Reta> construirPoligono() {
		acharExtremos();
		calcularPontoMedioPoligono();
		ordenarPontos();

		int contadorInteracoes;
		double deterPontoMedio, deter;
		Ponto maisDistante;

		while (!pontosNaoCalculados.isEmpty()) {
			maisDistante = pontosNaoCalculados.get(0);
			contadorInteracoes = 0;
			for (Reta r : retasPoligono) {
				deterPontoMedio = testarAlinhamento(pontoMedio, r);
				deter = testarAlinhamento(maisDistante, r);
				if (Math.signum(deter) != Math.signum(deterPontoMedio)) {
					criarNovasRetas(maisDistante, r);
					pontosNaoCalculados.remove(maisDistante);
					break;
				}
				contadorInteracoes++;
				if (contadorInteracoes == retasPoligono.size()) {
					pontosNaoCalculados.remove(maisDistante);
				}
			}
		}

		return retasPoligono;
	}

	public String getPolygonToBelief() {
		String s = "polygon([";
		for (Reta r : retasPoligono)
			s += "rule(" + r.getOrigem().getX() + "," + r.getOrigem().getY() + "," + r.getDestino().getX() + ","
					+ r.getDestino().getY() + "),";
		s = s.substring(0, s.length() - 1);
		return s + "])";
	}

	public String getPointsOfPolygonToBelief() {
		List<Ponto> pontos = obterPontos(retasPoligono);
		String s = buildBelief(pontos);
		return s;
	}

	public String getPointsOfPolygonAdjusted() {
		List<Ponto> pontos = obterPontos(retasPoligono);
		pontos = ajustarPontos(pontos);
		String s = buildBelief(pontos);
		return s;
	}

	private String buildBelief(List<Ponto> pontos) {
		String endBelief = tipoInstalacao.substring(0, 1).toUpperCase() + tipoInstalacao.substring(1);
		String fix = "pointsPolygon";
		String nameBelief = fix + endBelief;
		String s = nameBelief+"([";
		for (Ponto p : pontos) {
			double raio = distanceOfTwoPoints(p.getX(), p.getY(), pontoMedio.getX(), p.getY());
			s += tipoInstalacao + "(" + p.getNome() + "," + p.getX() + "," + p.getY() + "," + String.valueOf(raio)
					+ "),";
		}
		s = s.substring(0, s.length() - 1);
		s = s + "])";
		return s;
	}

	private List<Ponto> ajustarPontos(List<Ponto> pontos) {
		Map<String, List<Ponto>> storagesValidos = estoquesValidos(pontos);
		Map<String, List<Ponto>> mapOrganizado = organizaInstalacoesValidosPorAbrangencia(storagesValidos);
		Map<double[], String> selecaoInstalacaoPorAbrangencia = priorizaInstalacoesComMaiorAbrangencia(mapOrganizado);
		Map<String, String> nomeInstalacoes = obterNomeDosInstalacoesSelecionados(selecaoInstalacaoPorAbrangencia);
		List<Ponto> pontosAjustados = obterListaDosPontos(nomeInstalacoes, pontos);
		return pontosAjustados;
	}

	private List<Ponto> obterListaDosPontos(Map<String, String> nomeInstalacoes, List<Ponto> pontos) {
		List<Ponto> pontosAjustados = new ArrayList<>();
		for (String nome : nomeInstalacoes.keySet()) {
			for (Ponto p : pontos) {
				if (p.getNome().equals(nome)) {
					pontosAjustados.add(p);
					break;
				}
			}
		}
		return pontosAjustados;
	}

	private Map<String, String> obterNomeDosInstalacoesSelecionados(
			Map<double[], String> selecaoInstalacaoPorAbrangencia) {
		Map<String, String> nomeInstalacoes = new HashMap<>();
		for (double[] canto : selecaoInstalacaoPorAbrangencia.keySet()) {
			String nomeInstalacao = selecaoInstalacaoPorAbrangencia.get(canto);
			nomeInstalacoes.put(nomeInstalacao, nomeInstalacao);
		}
		return nomeInstalacoes;
	}

	private Map<double[], String> priorizaInstalacoesComMaiorAbrangencia(Map<String, List<Ponto>> mapOrganizado) {
		Map<double[], String> selecaoInstalacaoPorAbrangencia = new HashMap<>();
		for (String s : mapOrganizado.keySet()) {
			List<Ponto> pontosAux = mapOrganizado.get(s);
			for (Ponto p : pontosAux) {
				double[] canto = { p.getX(), p.getY() };
				boolean resposta = validaSeJaContemCantoNaSelecao(canto, selecaoInstalacaoPorAbrangencia);
				if (!resposta) {
					selecaoInstalacaoPorAbrangencia.put(canto, s);
				}
			}
		}
		return selecaoInstalacaoPorAbrangencia;
	}

	private Map<String, List<Ponto>> organizaInstalacoesValidosPorAbrangencia(
			Map<String, List<Ponto>> storagesValidos) {
		Map<String, List<Ponto>> mapOrganizado = storagesValidos.entrySet().stream().sorted(
				(e1, e2) -> (String.valueOf(e2.getValue().size()).compareTo(String.valueOf(e1.getValue().size()))))
				.collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue, (e1, e2) -> e1, LinkedHashMap::new));
		return mapOrganizado;
	}

	private Map<String, List<Ponto>> estoquesValidos(List<Ponto> pontos) {
		Map<String, List<Ponto>> storagesValidos = new HashMap<>();
		for (Ponto p : pontos) {
			double raio = distanceOfTwoPoints(p.getX(), p.getY(), pontoMedio.getX(), pontoMedio.getY());
			List<Ponto> pontosAux = validaComBordas(p.getX(), p.getY(), raio);
			storagesValidos.put(p.getNome(), pontosAux);
		}
		return storagesValidos;
	}

	private boolean validaSeJaContemCantoNaSelecao(double[] canto, Map<double[], String> selecaoInstalacao) {
		for (double[] keyCanto : selecaoInstalacao.keySet()) {
			if (keyCanto[0] == canto[0] && keyCanto[1] == canto[1]) {
				return true;
			}
		}
		return false;
	}

	private List<Ponto> obterPontos(List<Reta> retas) {
		List<Ponto> pontos = new ArrayList<>();
		for (Reta r : retas) {
			pontos.add(r.getOrigem());
		}
		return pontos;
	}

	private List<Ponto> validaComBordas(double x, double y, double raio) {
		List<Ponto> pontos = new ArrayList<>();
		for (int i = 0; i < 2; i++) {
			for (int j = 2; j < 4; j++) {
				double distanceOfTwoPoints = distanceOfTwoPoints(x, y, bordas[i], bordas[j]);
				if (raio > distanceOfTwoPoints) {
					pontos.add(new Ponto("", bordas[i], bordas[j]));
				}
			}
		}
		return pontos;
	}

	private double distanceOfTwoPoints(double lat1, double lon1, double lat2, double lon2) {
		if ((lat1 == lat2) && (lon1 == lon2)) {
			return 0;
		} else {
			double theta = lon1 - lon2;
			double dist = Math.sin(Math.toRadians(lat1)) * Math.sin(Math.toRadians(lat2))
					+ Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) * Math.cos(Math.toRadians(theta));
			dist = Math.acos(dist);
			dist = Math.toDegrees(dist);
			dist = dist * 60 * 1.1515;
			dist = dist * 1.609344;
			return (dist);
		}
	}

//	private double distanceOfMidPoint(double lat1, double lon1) {
//		double lat2=pontoMedio.getX();
//		double lon2=pontoMedio.getY();
//		if ((lat1 == lat2) && (lon1 == lon2)) {
//			return 0;
//		}
//		else {
//			double theta = lon1 - lon2;
//			double dist = Math.sin(Math.toRadians(lat1)) * Math.sin(Math.toRadians(lat2)) + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) * Math.cos(Math.toRadians(theta));
//			dist = Math.acos(dist);
//			dist = Math.toDegrees(dist);
//			dist = dist * 60 * 1.1515;
//				dist = dist * 1.609344;
//			return (dist);
//		}
//	}

	public void mostrarInformacoes() {
		System.out.println("Cima: " + maisAcima);
		System.out.println("Baixo: " + maisAbaixo);
		System.out.println("Esquerda: " + maisEsquerda);
		System.out.println("Direita: " + maisDireita);
		System.out.println("Ponto Medio: " + pontoMedio);
		System.out.println("Poligono: " + retasPoligono);
	}

	private void acharExtremos() {
		maisAcima = maisDireita =maisAbaixo = maisEsquerda = pontosNaoCalculados.get( 0 );

		for (Ponto p : pontosNaoCalculados) {
			if (maisAcima.getY() < p.getY()) {
				maisAcima = p;
				maisAcima.setNome(p.getNome());
			}
			if (maisAbaixo.getY() > p.getY()) {
				maisAbaixo = p;
				maisAbaixo.setNome(p.getNome());
			}
			if (maisEsquerda.getX() > p.getX()) {
				maisEsquerda = p;
				maisEsquerda.setNome(p.getNome());
			}
			if (maisDireita.getX() < p.getX()) {
				maisDireita = p;
				maisDireita.setNome(p.getNome());
			}
		}
		pontosNaoCalculados.remove(maisAcima);
		pontosNaoCalculados.remove(maisAbaixo);
		pontosNaoCalculados.remove(maisEsquerda);
		pontosNaoCalculados.remove(maisDireita);
		

		retasPoligono.add(new Reta(maisAbaixo, maisDireita));
		retasPoligono.add(new Reta(maisDireita, maisAcima));
		retasPoligono.add(new Reta(maisAcima, maisEsquerda));
		retasPoligono.add(new Reta(maisEsquerda, maisAbaixo));

		List<Reta> removerRetas = new ArrayList<>();
		for (Reta r : retasPoligono) {
			if (r.getOrigem().equals(r.getDestino())) {
				removerRetas.add(r);
			}
		}
		retasPoligono.removeAll(removerRetas);
	}

	private void calcularPontoMedioPoligono() {
		double xMedio = (maisAbaixo.getX() + maisAcima.getX() + maisDireita.getX() + maisEsquerda.getX()) / 4;
		double yMedio = (maisAbaixo.getY() + maisAcima.getY() + maisDireita.getY() + maisEsquerda.getY()) / 4;
		pontoMedio = new Ponto("Medio", xMedio, yMedio);
	}
//	
//	public String getMidPointOfPolygon() {
//		return "midPoint("+pontoMedio.getX() +","+pontoMedio.getY()+")";
//	}

	private double calcularDistancia(Ponto p1, Ponto p2) {
		return Math.sqrt(Math.pow(p1.getX() - p2.getX(), 2) + Math.pow(p1.getY() - p2.getY(), 2));
	}

	private double testarAlinhamento(Ponto p, Reta r) {
		double xA = p.getX();
		double yA = p.getY();
		double xB = r.getOrigem().getX();
		double yB = r.getOrigem().getY();
		double xC = r.getDestino().getX();
		double yC = r.getDestino().getY();
		return (xA * (yB - yC) + xB * (yC - yA) + xC * (yA - yB));
	}

	private void criarNovasRetas(Ponto p, Reta r) {
		Ponto aux = r.getDestino();
		r.setDestino(p);

		Reta novaReta = new Reta(p, aux);
		retasPoligono.add(novaReta);
	}

	private void ordenarPontos() {
		List<PontoComDistancia> lista = new ArrayList<>();
		PontoComDistancia pd;
		for (Ponto p : pontosNaoCalculados) {
			pd = new PontoComDistancia(p, calcularDistancia(p, pontoMedio));
			if (lista.isEmpty() || lista.get(lista.size() - 1).getDistancia() > pd.getDistancia()) {
				lista.add(pd);
			} else {
				for (int i = 0; i < lista.size(); i++) {
					if (lista.get(i).getDistancia() < pd.getDistancia()) {
						lista.add(i, pd);
						break;
					}
				}
			}
		}

		pontosNaoCalculados = new ArrayList<>();
		for (PontoComDistancia p : lista) {
			pontosNaoCalculados.add(p.getPonto());
		}
	}

	private Ponto calcularPontoMedio(Reta r) {
		return new Ponto("", (r.getOrigem().getX() + r.getDestino().getX()) / 2,
				(r.getOrigem().getY() + r.getDestino().getY()) / 2);
	}

	private Ponto calcularPontoMedio(Ponto p1, Ponto p2) {
		return new Ponto("", (p1.getX() + p2.getX()) / 2, (p1.getY() + p2.getY()) / 2);
	}

	public void setBordas(double[] bordas) {
		this.bordas = bordas;
	}

	private class PontoComDistancia {
		private Ponto ponto;
		private double distancia;

		private PontoComDistancia(Ponto ponto, double distancia) {
			this.ponto = ponto;
			this.distancia = distancia;
		}

		public Ponto getPonto() {
			return ponto;
		}

		public double getDistancia() {
			return distancia;
		}

		public String toString() {
			return "Ponto: " + ponto + ", Distancia: " + distancia;
		}
	}

	public synchronized Ponto calcularPonto(double x, double y) {
		Ponto vertice = new Ponto("", x, y);
		Reta retaMaisProxima = null;
		double distanciaMaisProximo = Double.MAX_VALUE;
		Ponto pontoMedioReta = null;
		double d;
		for (Reta r : retasPoligono) {
			pontoMedioReta = calcularPontoMedio(r);
			d = calcularDistancia(vertice, pontoMedioReta);
			if (distanciaMaisProximo > d) {
				retaMaisProxima = r;
				distanciaMaisProximo = d;
			}
		}
		pontoMedioReta = calcularPontoMedio(retaMaisProxima);
		return calcularPontoMedio(vertice, pontoMedioReta);
	}

}
