package jp.nyatla.nyartoolkit.as3.core.raster.rgb 
{
	import jp.nyatla.nyartoolkit.as3.core.rasterreader.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.*;
	public class NyARRgbRaster extends NyARRgbRaster_BasicClass
	{
		protected var _ref_buf:Object;

		private var _reader:INyARRgbPixelReader;
		private var _buffer_reader:INyARBufferReader;
		private function init(i_size:NyARIntSize,i_raster_type:int):void
		{
			switch(i_raster_type)
			{
				case INyARBufferReader.BUFFERFORMAT_INT1D_X8R8G8B8_32:
					this._ref_buf=new Vector.<int>(i_size.w*i_size.h);
					this._reader=new NyARRgbPixelReader_INT1D_X8R8G8B8_32(Vector.<int>(this._ref_buf),i_size);
					break;
				default:
					throw new NyARException();
			}
			this._buffer_reader=new NyARBufferReader(this._ref_buf,i_raster_type);			
		}
		public function NyARRgbRaster(i_size:NyARIntSize,i_raster_type:int)
		{
			super(i_size);
			init(i_size,i_raster_type);
			return;
		}
		public override function getRgbPixelReader():INyARRgbPixelReader
		{
			return this._reader;
		}
		public override function getBufferReader():INyARBufferReader
		{
			return this._buffer_reader;
		}	
	}


}