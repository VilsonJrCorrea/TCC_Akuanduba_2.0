package calculos;

import java.util.ArrayList;
import java.util.List;

import cartago.*;
import jason.asSyntax.ASSyntax;
import jason.asSyntax.Literal;
import jason.asSyntax.parser.ParseException;

public class ARTGreyZoneToStorages extends Artifact {
	private List<Ponto> pointsForStorages = new ArrayList<Ponto>();
	Calculos calcToGrayOfStorages;
	
	void init() {
	}

	@OPERATION
	void addPoint( String name,double x, double y) {
		pointsForStorages.add( new Ponto(name, x, y) );
	}
	
	@OPERATION
	void buildPolygonForStorages() {
		calcToGrayOfStorages = new Calculos( pointsForStorages );
		calcToGrayOfStorages.construirPoligono();
//		System.out.println("INTERNO: construindo o poligono !" );
	}
	
	@OPERATION
	void dismantlePolygonOfStorages() {
		pointsForStorages.clear();
		calcToGrayOfStorages = null;
	}
	
	@OPERATION
	void getPolygonOfStorages( OpFeedbackParam<Literal> retorno ) {
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

