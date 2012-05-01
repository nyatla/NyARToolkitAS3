package org.libspark.flartoolkit.pv3d 
{
	import flash.display.BitmapData;
	import org.papervision3d.core.math.Matrix3D;
	import flash.media.Camera;
	import jp.nyatla.nyartoolkit.as3.core.types.matrix.*;
	import jp.nyatla.nyartoolkit.as3.markersystem.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.cameras.*;	
	/**
	 * ...
	 * @author nyatla
	 */
	public class FLARPv3dMarkerSystem extends NyARMarkerSystem
	{
		public static const AXIS_MODE_ORIGINAL:int = 0;
		public static const AXIS_MODE_PV3D:int = 2;
		private var _camera:FLARCamera3D;
		private var _viewport:Viewport3D;
		private var _axix_mode:int;
		
		public function FLARPv3dMarkerSystem(i_config:INyARMarkerSystemConfig,i_axis_mode:int=AXIS_MODE_ORIGINAL)
		{
			super(i_config);
			this._axix_mode = i_axis_mode;
		}
		protected override function initInstance(i_config:INyARMarkerSystemConfig):void
		{
			//super part
			this._sqdetect=new SquareDetect(i_config);
			this._hist_th=i_config.createAutoThresholdArgorism();			
			//next part
			this._camera = new FLARCamera3D(this._ref_param);
		}
		/**
		 * AR映像向けにセットしたPaperVision3Dカメラを返します。
		 * @return
		 */
		public function getPv3dCamera():Camera3D
		{
			return this._camera;
		}
		public override function setProjectionMatrixClipping(i_near:Number,i_far:Number):void
		{
			super.setProjectionMatrixClipping(i_near, i_far);
			this._camera.setParam(this._ref_param);
		}
		/**
		 * この関数は、i_idの姿勢変換行列をi_3d_objectへセットします。
		 * @param	i_id
		 * @param	i_3d_object
		 */
		public function getPv3dMarkerMatrix(i_id:int,i_mat3d:org.papervision3d.core.math.Matrix3D):void
		{
			var r:NyARDoubleMatrix44 = this.getMarkerMatrix(i_id);
			switch(this._axix_mode) {
			case AXIS_MODE_PV3D:
				i_mat3d.n11 =  r.m00;  i_mat3d.n12 =  r.m01;  i_mat3d.n13 = -r.m02;  i_mat3d.n14 =  r.m03;
				i_mat3d.n21 = -r.m10;  i_mat3d.n22 = -r.m11;  i_mat3d.n23 =  r.m12;  i_mat3d.n24 = -r.m13;
				i_mat3d.n31 =  r.m20;  i_mat3d.n32 =  r.m21;  i_mat3d.n33 = -r.m22;  i_mat3d.n34 =  r.m23;
				break;
			case AXIS_MODE_ORIGINAL:
				i_mat3d.n11 =  r.m01;  i_mat3d.n12 =  r.m00;  i_mat3d.n13 =  r.m02;  i_mat3d.n14 =  r.m03;
				i_mat3d.n21 = -r.m11;  i_mat3d.n22 = -r.m10;  i_mat3d.n23 = -r.m12;  i_mat3d.n24 = -r.m13;
				i_mat3d.n31 =  r.m21;  i_mat3d.n32 =  r.m20;  i_mat3d.n33 =  r.m22;  i_mat3d.n34 =  r.m23;
				break;
			}
		}
		
		//
		// This reogion may be moved to NyARJ2seMarkerSystem.
		//
		
		/**
		 * BitmapDataを元にARマーカを登録します。
		 * BitmapDataの画像サイズは問いません。画像のうち、外周をi_patt_edge_percentageをエッジとして取り除いたものから、i_resolution^2のマーカを作ります。
		 * @param	i_img
		 * 基にするマーカ画像
		 * @param	i_patt_resolution
		 * 評価パターンの解像度(ex.16)
		 * @param	i_patt_edge_percentage
		 * 外周エッジの割合(ex.20%=20)
		 * @param	i_marker_size
		 * 物理的なマーカサイズ[mm]
		 * @return
		 */
		public function addARMarker_4(i_img:BitmapData, i_patt_resolution:int, i_patt_edge_percentage:int, i_marker_size:Number):int
		{
			var w:int=i_img.width;
			var h:int=i_img.height;
			var bmr:FLARRgbRaster=new FLARRgbRaster(i_img);
			var c:NyARCode=new NyARCode(i_patt_resolution,i_patt_resolution);
			//ラスタからマーカパターンを切り出す。
			var pc:INyARPerspectiveCopy=INyARPerspectiveCopy(bmr.createInterface(INyARPerspectiveCopy));
			var tr:INyARRgbRaster=new NyARRgbRaster(i_patt_resolution,i_patt_resolution);
			pc.copyPatt_3(0,0,w,0,w,h,0,h,i_patt_edge_percentage, i_patt_edge_percentage,4, tr);
			//切り出したパターンをセット
			c.setRaster_2(tr);
			return super.addARMarker(c,i_patt_edge_percentage,i_marker_size);
		}
		/**
		 * マーカ平面の任意四角領域から画像を剥がして返します。
		 * @param	i_id
		 * @param	i_sensor
		 * @param	i_x1
		 * @param	i_y1
		 * @param	i_x2
		 * @param	i_y2
		 * @param	i_x3
		 * @param	i_y3
		 * @param	i_x4
		 * @param	i_y4
		 * @param	i_img
		 */
		public function getMarkerPlaneImage_3(
			i_id:int,
			i_sensor:NyARSensor,
			i_x1:int,i_y1:int,
			i_x2:int,i_y2:int,
			i_x3:int,i_y3:int,
			i_x4:int,i_y4:int,
			i_img:BitmapData):void
			{
				var bmr:FLARRgbRaster=new FLARRgbRaster(i_img);
				super.getMarkerPlaneImage(i_id, i_sensor, i_x1, i_y1, i_x2, i_y2, i_x3, i_y3, i_x4, i_y4,bmr);
				return;
			}
		/**
		 * この関数は、{@link #getMarkerPlaneImage(int, NyARSensor, int, int, int, int, INyARRgbRaster)}
		 * のラッパーです。取得画像を{@link #BufferedImage}形式で返します。
		 * @param i_id
		 * マーカid
		 * @param i_sensor
		 * 画像を取得するセンサオブジェクト。通常は{@link #update(NyARSensor)}関数に入力したものと同じものを指定します。
		 * @param i_l
		 * @param i_t
		 * @param i_w
		 * @param i_h
		 * @param i_raster
		 * 出力先のオブジェクト
		 * @throws NyARException
		 */
		public function getMarkerPlaneImage_4(
			i_id:int,
			i_sensor:NyARSensor ,
			i_l:int,i_t:int,
			i_w:int,i_h:int,
			i_img:BitmapData):void
		{
			var bmr:FLARRgbRaster=new FLARRgbRaster(i_img);
			super.getMarkerPlaneImage_2(i_id, i_sensor, i_l, i_t, i_w, i_h, bmr);
			this.getMarkerPlaneImage(i_id,i_sensor,i_l+i_w-1,i_t+i_h-1,i_l,i_t+i_h-1,i_l,i_t,i_l+i_w-1,i_t,bmr);
			return;
		}
	}
}

import org.libspark.flartoolkit.core.squaredetect.*;
import org.libspark.flartoolkit.markersystem.*;
import jp.nyatla.nyartoolkit.as3.markersystem.*;
import jp.nyatla.nyartoolkit.as3.core.squaredetect.*;



class SquareDetect implements INyARMarkerSystemSquareDetect
{
	private var _sd:FLARSquareContourDetector;
	public function SquareDetect(i_config:INyARMarkerSystemConfig)
	{
		this._sd=new FLARSquareContourDetector(i_config.getScreenSize());
	}
	public function detectMarkerCb(i_sensor:NyARSensor,i_th:int,i_handler:NyARSquareContourDetector_CbHandler):void
	{
		this._sd.detectMarker((FLARSensor(i_sensor)).getBinImage(i_th),i_handler);
	}
}
