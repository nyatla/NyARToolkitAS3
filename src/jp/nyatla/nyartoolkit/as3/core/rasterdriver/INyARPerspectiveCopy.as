package jp.nyatla.nyartoolkit.as3.core.rasterdriver 
{
/**
 * このインタフェイスは、ラスタから射影変換画像を取得するインタフェイスを提供します。
 *
 */
public interface INyARPerspectiveCopy
{
	/**
	 * この関数は、i_outへパターンを出力します。
	 * @param i_vertex
	 * @param i_edge_x
	 * @param i_edge_y
	 * @param i_resolution
	 * @param i_out
	 * @return
	 * @throws NyARException
	 */
	public function copyPatt(i_vertex:Vector.<NyARIntPoint2d>,i_edge_x:int,i_edge_y:int,i_resolution:int,i_out:INyARRgbRaster):Boolean;
	public function copyPatt(i_vertex:Vector.<NyARDoublePoint2d>,i_edge_x:int,i_edge_y:int,i_resolution:int,i_out:INyARRgbRaster):Boolean;
	public function copyPatt(i_x1:Number,i_y1:Number,i_x2:Number,i_y2:Number,i_x3:Number,i_y3:Number,i_x4:Number,i_y4:Number,i_edge_x:int,i_edge_y:int,i_resolution:int,i_out:INyARRgbRaster):Boolean;
}

	
}