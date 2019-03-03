package calculos;

import java.util.ArrayList;
import java.util.List;

import cartago.*;
import jason.asSyntax.ASSyntax;
import jason.asSyntax.Literal;
import jason.asSyntax.parser.ParseException;

public class ARTGreyZoneToWells extends Artifact {
	private List<Ponto> pointsForWells = new ArrayList<Ponto>();
	private List<Ponto> pointsForStorages = new ArrayList<Ponto>();
	Calculos calcToGrayOfZoneWells;
	
	void init() {
	}

	@OPERATION
	void addPointToBuildWell( double x, double y) {
		pointsForWells.add( new Ponto("", x, y) );
	}
	
	@OPERATION
	void buildPolygonForWells() {
		calcToGrayOfZoneWells = new Calculos( pointsForWells );
		calcToGrayOfZoneWells.construirPoligono();
//		System.out.println("INTERNO: construindo o poligono !" );
	}
	
	@OPERATION
	void dismantlePolygonOfWells() {
		pointsForWells.clear();
		calcToGrayOfZoneWells = null;
	}
	
	@OPERATION
	void getPolygonOfWells( OpFeedbackParam<Literal> retorno ) {
		try {
			retorno.set(ASSyntax.parseLiteral( calcToGrayOfZoneWells.getPolygonToBelief() ) );
		} catch (ParseException e) {
			e.printStackTrace();
		}
	}
	
//	@OPERATION
//	void getMidPointOfPolygon(OpFeedbackParam<Literal>retorno) {
//		try {
//			retorno.set(ASSyntax.parseLiteral(calcToGrayOfZoneWells.getMidPointOfPolygon()));
//		} catch (ParseException e) {
//			e.printStackTrace();
//		}
//	}
	
	@OPERATION
	void getPoint( double lat, double lon, OpFeedbackParam<Literal> retorno ) {
		Ponto p = calcToGrayOfZoneWells.calcularPonto(lat, lon);
//		System.out.println( ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" + p.toString() );
		try {
			retorno.set( ASSyntax.parseLiteral( "point(" + p.getX() + "," + p.getY() + ")" ));
		} catch (ParseException e) {
			e.printStackTrace();
		}
//		System.out.println("INTERNO: getpoint" );
	}


}

