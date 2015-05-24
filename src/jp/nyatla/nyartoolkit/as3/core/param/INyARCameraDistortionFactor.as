/* 
 * PROJECT: NyARToolkitAS3
 * --------------------------------------------------------------------------------
 *
 * The NyARToolkitCS is AS3 edition NyARToolKit class library.
 * Copyright (C)2010 Ryo Iizuka
 *
 * This work is based on the ARToolKit developed by
 *   Hirokazu Kato
 *   Mark Billinghurst
 *   HITLab, University of Washington, Seattle
 * http://www.hitl.washington.edu/artoolkit/
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as publishe
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * For further information please contact.
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp> or <nyatla(at)nyatla.jp>
 * 
 */
package jp.nyatla.nyartoolkit.as3.core.param
{
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	/**
	 * カメラの歪み成分を格納するクラスと、補正関数群
	 * http://www.hitl.washington.edu/artoolkit/Papers/ART02-Tutorial.pdf
	 * 11ページを読むといいよ。
	 * 
	 * x=x(xi-x0),y=s(yi-y0)
	 * d^2=x^2+y^2
	 * p=(1-fd^2)
	 * xd=px+x0,yd=py+y0
	 */
	public interface INyARCameraDistortionFactor
	{
		function copyFrom(i_ref:INyARCameraDistortionFactor):void;
		/**
		 * 配列の値をファクタ値としてセットする。
		 * @param i_factor
		 * 4要素以上の配列
		 */
		function setValue(i_factor:Vector.<Number>):void;
		function getValue(o_factor:Vector.<Number>):void;
		/**
		 * この関数は、歪みパラメータをスケール倍します。
		 * パラメータ値は、スケール値の大きさだけ、拡大、又は縮小します。
		 * @param i_x_scale
		 * x方向のパラメータ倍率
		 * @param i_y_scale
		 * y方向のパラメータ倍率
		 */
		function changeScale(i_x_scale:Number, i_y_scale:Number):void;
		/**
		 * int arParamIdeal2Observ( const double dist_factor[4], const double ix,const double iy,double *ox, double *oy ) 関数の代替関数
		 * 
		 * @param i_in
		 * @param o_out
		 */
		function ideal2Observ(i_in:NyARDoublePoint2d, o_out:NyARDoublePoint2d):void;
		/**
		 * 理想座標から、観察座標系へ変換します。
		 * @param i_in
		 * @param o_out
		 */
		function ideal2Observ_2(i_in:NyARDoublePoint2d, o_out:NyARIntPoint2d):void;
		/**
		 * この関数は、座標点を理想座標系から観察座標系へ変換します。
		 * @param i_in
		 * 変換元の座標
		 * @param o_out
		 * 変換後の座標を受け取るオブジェクト
		 */
		function ideal2Observ_4(i_x:Number, i_y:Number, o_out:NyARDoublePoint2d):void;
		/**
		 * 理想座標から、観察座標系へ変換します。
		 * @param i_x
		 * @param i_y
		 * @param o_out
		 */
		function ideal2Observ_3(i_x:Number, i_y:Number, o_out:NyARIntPoint2d):void;
		

		/**
		 * 理想座標から、観察座標系へ変換します。
		 * @param i_in
		 * @param o_out
		 * @param i_size
		 */
		function ideal2ObservBatch(i_in:Vector.<NyARDoublePoint2d>, o_out:Vector.<NyARDoublePoint2d>, i_size:int):void;

		/**
		 * 複数の座標点について、観察座標から、理想座標系へ変換します。
		 * @param i_in
		 * @param o_out
		 * @param i_size
		 */
		function ideal2ObservBatch_2(i_in:Vector.<NyARDoublePoint2d>, o_out:Vector.<NyARIntPoint2d>, i_size:int):void;
		
		/**
		 * ARToolKitの観察座標から、理想座標系への変換です。
		 * 樽型歪みを解除します。
		 * @param ix
		 * @param iy
		 * @param o_point
		 */
		function observ2Ideal_3(ix:Number, iy:Number, o_point:NyARDoublePoint2d):void;
		/**
		 * {@link #observ2Ideal(double, double, NyARDoublePoint2d)}のラッパーです。
		 * i_inとo_pointには、同じオブジェクトを指定できます。
		 * @param i_in
		 * @param o_point
		 */	
		function observ2Ideal_2(i_in:NyARDoublePoint2d, o_point:NyARDoublePoint2d):void;
		/**
		 * 座標配列全てに対して、{@link #observ2Ideal(double, double, NyARDoublePoint2d)}を適応します。
		 * @param i_in
		 * @param o_out
		 * @param i_size
		 */
		function observ2IdealBatch(i_in:Vector.<NyARDoublePoint2d>, o_out: Vector.<NyARDoublePoint2d>, i_size:int):void;
	}
}