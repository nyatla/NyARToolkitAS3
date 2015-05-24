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
	import jp.nyatla.nyartoolkit.as3.core.types.matrix.*;
	import flash.utils.*;
	
	/**
	 * typedef struct { int xsize, ysize; double mat[3][4]; double dist_factor[4]; } ARParam;
	 * NyARの動作パラメータを格納するクラス
	 *
	 */
	public class NyARParam
	{
		protected var _screen_size:NyARIntSize=new NyARIntSize();
		private static const SIZE_OF_PARAM_SET:int = 4 + 4 + (3 * 4 * 8) + (4 * 8);
		private var _dist:INyARCameraDistortionFactor;
		private var _projection_matrix:NyARPerspectiveProjectionMatrix =new NyARPerspectiveProjectionMatrix();
		/**
		 * テストパラメータを格納したインスタンスを生成します。
		 * @return
		 */
		public static function createDefaultParameter():NyARParam
		{
			var pm:ParamLoader=new ParamLoader();
			return new NyARParam(pm.size, pm.pmat, pm.dist_factor);
		}
		
		/**
		 * i_streamからARToolkitのカメラパラメータを読み出して、格納したインスタンスを生成します。
		 * @param i_stream
		 * @return
		 * @throws NyARException
		 */
		public static function createFromARParamFile(i_stream:ByteArray):NyARParam
		{
			var pm:ParamLoader=new ParamLoader(i_stream);
			return new NyARParam(pm.size, pm.pmat, pm.dist_factor);
		}
		public static function createFromCvCalibrateCamera2Result(i_w:int,i_h:int,i_intrinsic_matrix:Vector.<Number>,i_distortion_coeffs:Vector.<Number>):NyARParam
		{
			var pm:ParamLoader=new ParamLoader(i_w,i_h,i_intrinsic_matrix,i_distortion_coeffs);
			return new NyARParam(pm.size,pm.pmat,pm.dist_factor);
		}
		public function NyARParam(i_screen_size:NyARIntSize,i_projection_mat:NyARPerspectiveProjectionMatrix,i_dist_factor:INyARCameraDistortionFactor)
		{
			this._screen_size=new NyARIntSize(i_screen_size);
			this._dist=i_dist_factor;
			this._projection_matrix=i_projection_mat;
		}
		public function getScreenSize():NyARIntSize
		{
			return this._screen_size;
		}

		public function getPerspectiveProjectionMatrix():NyARPerspectiveProjectionMatrix 
		{
			return this._projection_matrix;
		}
		public function getDistortionFactor():INyARCameraDistortionFactor
		{
			return this._dist;
		}
		/**
		 * 
		 * @param i_factor
		 * NyARCameraDistortionFactorにセットする配列を指定する。要素数は4であること。
		 * @param i_projection
		 * NyARPerspectiveProjectionMatrixセットする配列を指定する。要素数は12であること。
		 */
		public function setValue(i_factor:Vector.<Number>,i_projection:Vector.<Number>):void
		{
			this._dist.setValue(i_factor);
			this._projection_matrix.setValue(i_projection);
			return;
		}
		/**
		 * int arParamChangeSize( ARParam *source, int xsize, int ysize, ARParam *newparam );
		 * 関数の代替関数 サイズプロパティをi_xsize,i_ysizeに変更します。
		 * @param i_xsize
		 * @param i_ysize
		 * @param newparam
		 * @return
		 * 
		 */
		public function changeScreenSize(i_xsize:int,i_ysize:int):void
		{
			var x_scale:Number = Number(i_xsize) / Number(this._screen_size.w);// scale = (double)xsize / (double)(source->xsize);
			var y_scale:Number = Number(i_ysize) / Number(this._screen_size.h);// scale = (double)xsize / (double)(source->xsize);
			//スケールを変更
			this._dist.changeScale(x_scale,y_scale);
			this._projection_matrix.changeScale(x_scale,y_scale);
			this._screen_size.w = i_xsize;// newparam->xsize = xsize;
			this._screen_size.h = i_ysize;// newparam->ysize = ysize;
			return;

		}
		/**
		 * この関数は、現在のスクリーンサイズを変更します。
		 * {@link #changeScreenSize(int, int)のラッパーです。
		 * @param i_s
		 */
		public function changeScreenSize_2(i_s:NyARIntSize):void
		{
			this.changeScreenSize(i_s.w,i_s.h);
		}
		/**
		 * 右手系の視錐台を作ります。
		 * 計算結果を多用するときは、キャッシュするようにして下さい。
		 * @param i_dist_min
		 * @param i_dist_max
		 * @param o_frustum
		 */
		public function makeCameraFrustumRH(i_dist_min:Number,i_dist_max:Number,o_frustum:NyARDoubleMatrix44):void
		{
			this._projection_matrix.makeCameraFrustumRH(this._screen_size.w, this._screen_size.h, i_dist_min, i_dist_max, o_frustum);
			return;
		}
	}
}
import jp.nyatla.nyartoolkit.as3.core.*;
import jp.nyatla.nyartoolkit.as3.core.types.*;
import jp.nyatla.nyartoolkit.as3.core.utils.*;
import jp.nyatla.nyartoolkit.as3.core.types.matrix.*;
import jp.nyatla.nyartoolkit.as3.core.param.*;
import flash.utils.*;

/**
 * パラメータローダーです。
 */
class ParamLoader
{
	public var size:NyARIntSize;
	public var pmat:NyARPerspectiveProjectionMatrix;
	public var dist_factor:INyARCameraDistortionFactor;
	public function ParamLoader(...args:Array)
	{
		switch(args.length) {
		case 0:
			this.ParamLoader_0();
			break;
		case 1:
			this.ParamLoader_1o(ByteArray(args[0]));
			break;
		case 4:
			this.ParamLoader_4iioo(int(args[0]), int(args[1]),Vector.<Number>(args[2]),Vector.<Number>(args[3]));
			break;
		default:
			throw new NyARException();
		}		
	}
	/**
	 * intrinsic_matrixとdistortion_coeffsからインスタンスを初期化する。
	 * @param i_w
	 * カメラパラメータ生成時の画面サイズ
	 * @param i_h
	 * カメラパラメータ生成時の画面サイズ
	 * @param i_intrinsic_matrix 3x3 matrix このパラメータは、OpenCVのcvCalibrateCamera2関数が出力するintrinsic_matrixの値と合致します。
	 * @param i_distortion_coeffs 4x1 vector このパラメータは、OpenCVのcvCalibrateCamera2関数が出力するdistortion_coeffsの値と合致します。
	 */
	public function ParamLoader_4iioo(i_w:int,i_h:int,i_intrinsic_matrix:Vector.<Number>,i_distortion_coeffs:Vector.<Number>):void
	{
		this.size=new NyARIntSize(i_w,i_h);
		//dist factor
		var v4dist:NyARCameraDistortionFactorV4=new NyARCameraDistortionFactorV4();
		v4dist.setValue_2(this.size,i_intrinsic_matrix,i_distortion_coeffs);
		var s:Number=v4dist.getS();
		this.dist_factor=v4dist;
		//projection matrix
		this.pmat=new NyARPerspectiveProjectionMatrix();
		var r:NyARDoubleMatrix33=new NyARDoubleMatrix33();
		r.setValue(i_intrinsic_matrix);
		r.m00 /= s;
		r.m01 /= s;
		r.m10 /= s;
		r.m11 /= s;
		this.pmat.setValue_3(r, new NyARDoublePoint3d());
	}
	/**
	 * 標準パラメータでインスタンスを初期化します。
	 * @throws NyARException
	 */
	public function ParamLoader_0():void
	{
		var df:Vector.<Number>= Vector.<Number>([318.5,263.5,26.2,1.0127565206658486]);
		var pj:Vector.<Number>=Vector.<Number>([700.9514702992245,0,316.5,0,
						0,726.0941816535367,241.5,0.0,
						0.0,0.0,1.0,0.0,
						0.0,0.0,0.0,1.0]);
		this.size=new NyARIntSize(640,480);
		this.pmat=new NyARPerspectiveProjectionMatrix();
		this.pmat.setValue(pj);
		this.dist_factor=new NyARCameraDistortionFactorV2();
		this.dist_factor.setValue(df);
	}
	/**
	 * ストリームから読み出したデータでインスタンスを初期化します。
	 * @param i_stream
	 * @throws NyARException
	 */
	public function ParamLoader_1o(i_stream:ByteArray):void
	{
		try {
			var i:int;
			//読み出し
			var bis:ByteBufferedInputStream=new ByteBufferedInputStream(i_stream);
			var s:int=i_stream.length;
			bis.order(ByteBufferedInputStream.ENDIAN_BIG);
			//読み出したサイズでバージョンを決定
			var version_table:Vector.<int>=Vector.<int>([136,144,152,176]);
			var version:int=-1;
			for(i=0;i<version_table.length;i++){
				if(s%version_table[i]==0){
					version=i+1;
					break;
				}
			}
			//一致しなければ無し
			if(version==-1){
				throw new NyARException();
			}
			//size
			this.size=new NyARIntSize();
			this.size.setValue(bis.getInt(),bis.getInt());

			//projection matrix
			this.pmat=new NyARPerspectiveProjectionMatrix();
			var pjv:Vector.<Number> = new Vector.<Number>(16);
			for (i=0; i < 12; i++) {
				pjv[i]=bis.getDouble();
			}			
			pjv[12]=pjv[13]=pjv[14]=0;
			pjv[15]=1;
			this.pmat.setValue(pjv);
			
			//dist factor
			var df:Vector.<Number>;
			switch(version)
			{
			case 1://Version1
				df=new Vector.<Number>(NyARCameraDistortionFactorV2.NUM_OF_FACTOR);
				this.dist_factor=new NyARCameraDistortionFactorV2();
				break;
			case 4://Version4
				df=new Vector.<Number>(NyARCameraDistortionFactorV4.NUM_OF_FACTOR);
				this.dist_factor=new NyARCameraDistortionFactorV4();
				break;
			default:
				throw new NyARException();
			}
			for(i=0;i<df.length;i++){
				df[i]=bis.getDouble();
			}
			this.dist_factor.setValue(df);
		} catch (e:Error) {
			throw new NyARException(e.getStackTrace());
		}			
	}
}