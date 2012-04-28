package org.libspark.flartoolkit.markersystem 
{
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.analyzer.histogram.*;
	import jp.nyatla.nyartoolkit.as3.core.param.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
	import jp.nyatla.nyartoolkit.as3.core.squaredetect.*;
	import jp.nyatla.nyartoolkit.as3.core.transmat.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.types.matrix.*;
	import jp.nyatla.nyartoolkit.as3.markersystem.utils.*;
	import jp.nyatla.nyartoolkit.as3.markersystem.*;





	/**
	 * このクラスは、マーカベースARの制御クラスです。
	 * 複数のARマーカとNyIDの検出情報の管理機能、撮影画像の取得機能を提供します。
	 * このクラスは、ARToolKit固有の座標系を出力します。他の座標系を出力するときには、継承クラスで変換してください。
	 * レンダリングシステム毎にクラスを派生させて使います。Javaの場合には、OpenGL用の{@link NyARGlMarkerSystem}クラスがあります。
	 * 
	 * このクラスは、NyARMarkerSystemをFLARToolkit向けに改造したものです。
	 */
	public class FLARMarkerSystem extends  NyARMarkerSystem
	{
		
		/**
		 * コンストラクタです。{@link INyARMarkerSystemConfig}を元に、インスタンスを生成します。
		 * @param i_config
		 * 初期化済の{@link MarkerSystem}を指定します。
		 * @throws NyARException
		 */
		public function FLARMarkerSystem(i_config:INyARMarkerSystemConfig)
		{
			super(i_config);
		}
		protected override function initInstance(i_ref_config:INyARMarkerSystemConfig):void
		{
			this._sqdetect=new FLDetector(i_ref_config);
			this._hist_th=i_ref_config.createAutoThresholdArgorism();
		}
	}
}

import jp.nyatla.nyartoolkit.as3.core.*;
import jp.nyatla.nyartoolkit.as3.core.analyzer.histogram.*;
import jp.nyatla.nyartoolkit.as3.core.param.*;
import jp.nyatla.nyartoolkit.as3.core.raster.*;
import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
import jp.nyatla.nyartoolkit.as3.core.squaredetect.*;
import jp.nyatla.nyartoolkit.as3.core.transmat.*;
import jp.nyatla.nyartoolkit.as3.core.types.*;
import jp.nyatla.nyartoolkit.as3.core.types.matrix.*;
import jp.nyatla.nyartoolkit.as3.markersystem.utils.*;
import jp.nyatla.nyartoolkit.as3.markersystem.*;
import org.libspark.flartoolkit.core.squaredetect.*;
import org.libspark.flartoolkit.core.rasterfilter.*;
import org.libspark.flartoolkit.markersystem.*;

class FLDetector implements INyARMarkerSystemSquareDetect
{
	private var _sd:FLARSquareContourDetector;
	private var gs2bin:FLARGs2BinFilter;
	public function FLDetector(i_config:INyARMarkerSystemConfig)
	{
		this._sd=new FLARSquareContourDetector(i_config.getScreenSize());
	}
	public function detectMarkerCb(i_sensor:NyARSensor,i_th:int,i_handler:NyARSquareContourDetector_CbHandler):void
	{
		//GS->BIN変換
		this._sd.detectMarker(FLARSensor(i_sensor).getBinImage(i_th),i_handler);
	}
}

