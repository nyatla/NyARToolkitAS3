/* 
 * PROJECT: NyARToolkitAS3
 * --------------------------------------------------------------------------------
 * This work is based on the original ARToolKit developed by
 *   Hirokazu Kato
 *   Mark Billinghurst
 *   HITLab, University of Washington, Seattle
 * http://www.hitl.washington.edu/artoolkit/
 *
 * The NyARToolkitAS3 is AS3 edition ARToolKit class library.
 * Copyright (C)2010 Ryo Iizuka
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * For further information please contact.
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp> or <nyatla(at)nyatla.jp>
 * 
 */
package jp.nyatla.nyartoolkit.as3.core.squaredetect 
{
	import jp.nyatla.nyartoolkit.as3.core.param.*;
	import jp.nyatla.nyartoolkit.as3.core.labeling.rlelabeling.*;
	import jp.nyatla.nyartoolkit.as3.core.labeling.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	
	public class NyARSquareContourDetector_Rle extends NyARSquareContourDetector
	{
		private var _width:int ; 
		private var _height:int ; 
		private var _labeling:Labeling ; 
		private var _overlap_checker:NyARLabelOverlapChecker = new NyARLabelOverlapChecker(32) ; 
		private var _cpickup:NyARContourPickup = new NyARContourPickup();
		private var _coord2vertex:NyARCoord2SquareVertexIndexes = new NyARCoord2SquareVertexIndexes(); 
		private var _coord:NyARIntCoordinates ; 
		public function NyARSquareContourDetector_Rle( i_size:NyARIntSize )
		{ 
			//assert( ! (( NyARLabeling_Rle._sf_label_array_safe_reference ) ) );
			this._width = i_size.w ;
			this._height = i_size.h ;
			this._labeling = new Labeling( this._width , this._height ) ;
			var number_of_coord:int = ( this._width + this._height ) * 2 ;
			this._coord = new NyARIntCoordinates( number_of_coord ) ;
			return  ;
		}
	private var __detectMarker_mkvertex:Vector.<int> = new Vector.<int>(4); 
	public function detectMarker_2( i_raster:NyARGrayscaleRaster , i_area:NyARIntRect , i_th:int ):void
	{ 
		//assert( ! (( i_area.w * i_area.h > 0 ) ) );
		var flagment:NyARRleLabelFragmentInfoPtrStack = this._labeling.label_stack ;
		var overlap:NyARLabelOverlapChecker = this._overlap_checker ;
		this._labeling.labeling_4(i_raster , i_area , i_th) ;
		var label_num:int = flagment.getLength() ;
		if( label_num < 1 ) {
			return  ;
		}
		
		var labels:Vector.<Object> = flagment.getArray() ;
		var coord:NyARIntCoordinates = this._coord ;
		var mkvertex:Vector.<int> = this.__detectMarker_mkvertex ;
		overlap.setMaxLabels(label_num) ;
		for( var i:int = 0 ; i < label_num ; i++ ) {
			var label_pt:NyARRleLabelFragmentInfo = NyARRleLabelFragmentInfo(labels[i]);
			if ( !overlap.check(label_pt) )
			{
				continue ;
			}
			
			if ( !this._cpickup.getContour_4(i_raster, i_area, i_th, label_pt.entry_x, label_pt.clip_t, coord) )
			{
				continue ;
			}
			
			var label_area:int = label_pt.area ;
			if ( !this._coord2vertex.getVertexIndexes(coord, label_area, mkvertex) )
			{
				continue ;
			}
			
			this.onSquareDetect(coord , mkvertex) ;
			overlap.push(label_pt) ;
		}
		return  ;
	}
	
	public override function detectMarker_1( i_raster:NyARBinRaster ):void
	{ 
		var flagment:NyARRleLabelFragmentInfoPtrStack = this._labeling.label_stack ;
		var overlap:NyARLabelOverlapChecker = this._overlap_checker ;
		flagment.clear() ;
		this._labeling.labeling_1(i_raster) ;
		var label_num:int = flagment.getLength() ;
		if( label_num < 1 ) {
			return  ;
		}
		
		flagment.sortByArea() ;
		var labels:Vector.<Object> = flagment.getArray() ;
		var coord:NyARIntCoordinates = this._coord ;
		var mkvertex:Vector.<int> = this.__detectMarker_mkvertex ;
		overlap.setMaxLabels(label_num) ;
		for( var i:int = 0 ; i < label_num ; i++ ) {
			var label_pt:NyARRleLabelFragmentInfo = NyARRleLabelFragmentInfo(labels[i]);
			var label_area:int = label_pt.area ;
			if( !overlap.check(label_pt) ) {
				continue ;
			}
			
			if( !this._cpickup.getContour_1(i_raster, label_pt.entry_x, label_pt.clip_t, coord) ) {
				continue ;
			}
			
			if( !this._coord2vertex.getVertexIndexes(coord, label_area, mkvertex) ) {
				continue ;
			}
			
			this.onSquareDetect(coord , mkvertex) ;
			overlap.push(label_pt) ;
		}
		return  ;
	}
	

	}
}
import jp.nyatla.nyartoolkit.as3.core.labeling.*;
import jp.nyatla.nyartoolkit.as3.core.labeling.rlelabeling.*;
import jp.nyatla.nyartoolkit.as3.core.raster.*;
import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
import jp.nyatla.nyartoolkit.as3.core.types.*;

class Labeling extends NyARLabeling_Rle 
{
	public var label_stack:NyARRleLabelFragmentInfoPtrStack ; 
	private var _right:int ; 
	private var _bottom:int ; 
	public function Labeling( i_width:int , i_height:int )
	{ 
		super( i_width , i_height ) ;
		this.label_stack = new NyARRleLabelFragmentInfoPtrStack( i_width * i_height * 2048 / ( 320 * 240 ) + 32 ) ;
		this._bottom = i_height - 1 ;
		this._right = i_width - 1 ;
		return  ;
	}
	public override function labeling_4( i_raster:NyARGrayscaleRaster , i_area:NyARIntRect , i_th:int ):void
	{ 
		this.label_stack.clear() ;
		super.labeling_4(i_raster , i_area , i_th) ;
		this.label_stack.sortByArea() ;
	}
	
	public override function labeling_1( i_bin_raster:NyARBinRaster ):void
	{ 
		this.label_stack.clear() ;
		super.labeling_1(i_bin_raster) ;
		this.label_stack.sortByArea() ;
	}
	
	protected override function onLabelFound( i_label:NyARRleLabelFragmentInfo ):void
	{ 
		if( i_label.clip_l == 0 || i_label.clip_r == this._right ) {
			return  ;
		}
		
		if( i_label.clip_t == 0 || i_label.clip_b == this._bottom ) {
			return  ;
		}
		this.label_stack.push(i_label) ;
	}
	
}


