package calculos;

import java.util.ArrayList;
import java.util.List;

import cartago.*;
import jason.asSyntax.ASSyntax;
import jason.asSyntax.Literal;
import jason.asSyntax.parser.ParseException;

public class ARTGreyZoneToWorkshops extends Artifact {
	private List<Ponto> points = new ArrayList<Ponto>();
	Calculos calcToGrayOfStorages;
	private final String tipoInstalacao = "workshop";
	void init() {
	}

	@OPERATION
	void addPoint( String name,double x, double y) {
		points.add( new Ponto(name, x, y) );
	}
	
	@OPERATION
	void addBordas(double minlat,double maxlat,double minlon,double maxlon) {
		double bordas [] = {minlat,maxlat,minlon,maxlon};
		calcToGrayOfStorages.setBordas(bordas);
	}
//	
	
	@OPERATION
	void buildPolygonForWorkshop() {
		calcToGrayOfStorages = new Calculos( tipoInstalacao,points );
		calcToGrayOfStorages.construirPoligono();
//		System.out.println("INTERNO: construindo o poligono !" );
	}
	
	@OPERATION
	void dismantlePolygonOfStorages() {
		points.clear();
		calcToGrayOfStorages = null;
	}
	
	@OPERATION
	void getPolygonOfWorkshops( OpFeedbackParam<Literal> retorno ) {
		try {
			retorno.set(ASSyntax.parseLiteral( calcToGrayOfStorages.getPolygonToBelief() ) );
		} catch (ParseException e) {
			e.printStackTrace();
		}
	}
	

	
	@OPERATION
	void getPointsOfPolygon(OpFeedbackParam<Literal>retorno) {
		try {
			retorno.set(ASSyntax.parseLiteral(calcToGrayOfStorages.getPointsOfPolygonToBelief()));
		} catch (ParseException e) {
			e.printStackTrace();
		}
	}
	
	@OPERATION
	void getPointsOfPolygonAdjusted(OpFeedbackParam<Literal>retorno) {
		try {
			retorno.set(ASSyntax.parseLiteral(calcToGrayOfStorages.getPointsOfPolygonAdjusted()));
		} catch (ParseException e) {
			e.printStackTrace();
		}
	}
	
	
	@OPERATION
	void getPoint( double lat, double lon, OpFeedbackParam<Literal> retorno ) {
		Ponto p = calcToGrayOfStorages.calcularPonto(lat, lon);
//		System.out.println( ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" + p.toString() );
		try {
			retorno.set( ASSyntax.parseLiteral( "point(" + p.getX() + "," + p.getY() + ")" ));
		} catch (ParseException e) {
			e.printStackTrace();
		}
//		System.out.println("INTERNO: getpoint" );
	}


}

