package org.libspark.flartoolkit.pv3d 
{
	import flash.display.BitmapData;
	import org.papervision3d.core.math.Matrix3D;
	import flash.media.Camera;
	import jp.nyatla.nyartoolkit.as3.core.types.matrix.*;
	import jp.nyatla.nyartoolkit.as3.markersystem.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.markersystem.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
	import org.papervision3d.core.math.Number2D;
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.cameras.*;	
	/**
	 * ...
	 * @author nyatla
	 */
	public class FLARPV3DMarkerSystem extends FLARMarkerSystem
	{
		public static const AXIS_MODE_ORIGINAL:int = 0;
		public static const AXIS_MODE_PV3D:int = 2;
		private var _camera:FLARCamera3D;
		private var _axix_mode:int;
		
		public function FLARPV3DMarkerSystem(i_config:INyARMarkerSystemConfig,i_axis_mode:int=AXIS_MODE_ORIGINAL)
		{
			super(i_config);
			this._axix_mode = i_axis_mode;
			this._camera = new FLARCamera3D(this._ref_param);
			this.addObserver(new Observer(this._camera));
		}
		/**
		 * AR映像向けにセットしたPaperVision3Dカメラを返します。
		 * @return
		 */
		public function getPV3DCamera():Camera3D
		{
			return this._camera;
		}
		/**
		 * この関数は、i_idの姿勢変換行列をi_3d_objectへセットします。
		 * 座標系は、コンストラクタに設定した座標モードの影響を受けます。
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
		public override function getMarkerPlanePos(i_id:int, i_x:int, i_y:int, i_out:NyARDoublePoint3d):NyARDoublePoint3d
		{
			var p:NyARDoublePoint3d = super.getMarkerPlanePos(i_id, i_x, i_y, i_out);
			var px:Number = p.x;
			p.x = p.y;
			p.y = px;
			return p;
		}		
	}
}
import jp.nyatla.nyartoolkit.as3.markersystem.*;
import org.libspark.flartoolkit.pv3d.*;
import jp.nyatla.nyartoolkit.as3.core.param.*;
class Observer implements INyARSingleCameraSystemObserver
{
	private var _ref_camera:FLARCamera3D;
	public function Observer(i_ref_camera:FLARCamera3D)
	{
		this._ref_camera = i_ref_camera;
	}
	public function onUpdateCameraParametor(i_param:NyARParam, i_near:Number, i_far:Number):void	
	{
		this._ref_camera.setParam(i_param, i_near, i_far);
	}
}