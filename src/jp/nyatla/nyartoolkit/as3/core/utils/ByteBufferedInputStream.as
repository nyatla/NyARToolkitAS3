package jp.nyatla.nyartoolkit.as3.core.utils 
{

	import flash.utils.*;
	import jp.nyatla.as3utils.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	/**
	 * このクラスは、{@link InputStream}からバッファリングしながら読み出します。
	 *
	 */
	public class ByteBufferedInputStream
	{
		public static const ENDIAN_LITTLE:int=1;
		public static const ENDIAN_BIG:int=2;
		private var _bb:ByteArray;
		public function ByteBufferedInputStream(i_stream:ByteArray)
		{
			this._bb=i_stream;
			this._bb.endian=Endian.LITTLE_ENDIAN;
		}
		/**
		 * マルチバイト読み込み時のエンディアン.{@link #ENDIAN_BIG}か{@link #ENDIAN_LITTLE}を設定してください。
		 * @param i_order
		 */
		public function order(i_order:int):void
		{
			this._bb.endian=(i_order==ENDIAN_LITTLE?Endian.LITTLE_ENDIAN:Endian.BIG_ENDIAN);
		}
		/**
		 * streamからi_bufへi_sizeだけ読み出します。
		 * @param i_buf
		 * @param i_size
		 * @return
		 * 読み出したバイト数
		 * @throws NyARException
		 */
		public function readBytes(i_buf:ByteArray, i_size:int):int
		{
			this._bb.readBytes(i_buf, 0, i_size);
			return i_size;
		}	
		public function getInt():int
		{
			return this._bb.readInt();
		}
		public function getByte():int
		{
			return this._bb.readByte();
		}
		public function getFloat():Number
		{
			return this._bb.readFloat();
		}
		public function getDouble():Number
		{
			return this._bb.readDouble();
		}
	}
}