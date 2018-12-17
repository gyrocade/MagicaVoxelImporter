//
//  MV_Model.swift
//  Magica Voxel Importer
//
//  Created by Will Powers on 12/29/16.
//  Copyright (c) 2016 Gyrocade, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial
//  portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT 
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO 
//  EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
//  USE OR OTHER DEALINGS IN THE SOFTWARE.


import Foundation

//================
// RGBA
//================
struct MV_RGBA {
    var r:UInt8 = 0, g:UInt8 = 0, b:UInt8 = 0, a:UInt8 = 0
}

//================
// Voxel
//================
struct MV_Voxel {
    var x:UInt8 = 0, y:UInt8 = 0, z:UInt8 = 0, colorIndex:UInt8 = 0
}

class MV_Model {
    static let mv_default_palette:[CUnsignedInt] = [
        0xFFFFFFFF,0xFFFFCCFF,0xFFFF99FF,0xFFFF66FF,0xFFFF33FF,0xFFFF00FF,0xFFCCFFFF,0xFFCCCCFF,0xFFCC99FF,
        0xFFCC66FF,0xFFCC33FF,0xFFCC00FF,0xFF99FFFF,0xFF99CCFF,0xFF9999FF,0xFF9966FF,0xFF9933FF,0xFF9900FF,
        0xFF66FFFF,0xFF66CCFF,0xFF6699FF,0xFF6666FF,0xFF6633FF,0xFF6600FF,0xFF33FFFF,0xFF33CCFF,0xFF3399FF,
        0xFF3366FF,0xFF3333FF,0xFF3300FF,0xFF00FFFF,0xFF00CCFF,0xFF0099FF,0xFF0066FF,0xFF0033FF,0xFF0000FF,
        0xCCFFFFFF,0xCCFFCCFF,0xCCFF99FF,0xCCFF66FF,0xCCFF33FF,0xCCFF00FF,0xCCCCFFFF,0xCCCCCCFF,0xCCCC99FF,
        0xCCCC66FF,0xCCCC33FF,0xCCCC00FF,0xCC99FFFF,0xCC99CCFF,0xCC9999FF,0xCC9966FF,0xCC9933FF,0xCC9900FF,
        0xCC66FFFF,0xCC66CCFF,0xCC6699FF,0xCC6666FF,0xCC6633FF,0xCC6600FF,0xCC33FFFF,0xCC33CCFF,0xCC3399FF,
        0xCC3366FF,0xCC3333FF,0xCC3300FF,0xCC00FFFF,0xCC00CCFF,0xCC0099FF,0xCC0066FF,0xCC0033FF,0xCC0000FF,
        0x99FFFFFF,0x99FFCCFF,0x99FF99FF,0x99FF66FF,0x99FF33FF,0x99FF00FF,0x99CCFFFF,0x99CCCCFF,0x99CC99FF,
        0x99CC66FF,0x99CC33FF,0x99CC00FF,0x9999FFFF,0x9999CCFF,0x999999FF,0x999966FF,0x999933FF,0x999900FF,
        0x9966FFFF,0x9966CCFF,0x996699FF,0x996666FF,0x996633FF,0x996600FF,0x9933FFFF,0x9933CCFF,0x993399FF,
        0x993366FF,0x993333FF,0x993300FF,0x9900FFFF,0x9900CCFF,0x990099FF,0x990066FF,0x990033FF,0x990000FF,
        0x66FFFFFF,0x66FFCCFF,0x66FF99FF,0x66FF66FF,0x66FF33FF,0x66FF00FF,0x66CCFFFF,0x66CCCCFF,0x66CC99FF,
        0x66CC66FF,0x66CC33FF,0x66CC00FF,0x6699FFFF,0x6699CCFF,0x669999FF,0x669966FF,0x669933FF,0x669900FF,
        0x6666FFFF,0x6666CCFF,0x666699FF,0x666666FF,0x666633FF,0x666600FF,0x6633FFFF,0x6633CCFF,0x663399FF,
        0x663366FF,0x663333FF,0x663300FF,0x6600FFFF,0x6600CCFF,0x660099FF,0x660066FF,0x660033FF,0x660000FF,
        0x33FFFFFF,0x33FFCCFF,0x33FF99FF,0x33FF66FF,0x33FF33FF,0x33FF00FF,0x33CCFFFF,0x33CCCCFF,0x33CC99FF,
        0x33CC66FF,0x33CC33FF,0x33CC00FF,0x3399FFFF,0x3399CCFF,0x339999FF,0x339966FF,0x339933FF,0x339900FF,
        0x3366FFFF,0x3366CCFF,0x336699FF,0x336666FF,0x336633FF,0x336600FF,0x3333FFFF,0x3333CCFF,0x333399FF,
        0x333366FF,0x333333FF,0x333300FF,0x3300FFFF,0x3300CCFF,0x330099FF,0x330066FF,0x330033FF,0x330000FF,
        0x00FFFFFF,0x00FFCCFF,0x00FF99FF,0x00FF66FF,0x00FF33FF,0x00FF00FF,0x00CCFFFF,0x00CCCCFF,0x00CC99FF,
        0x00CC66FF,0x00CC33FF,0x00CC00FF,0x0099FFFF,0x0099CCFF,0x009999FF,0x009966FF,0x009933FF,0x009900FF,
        0x0066FFFF,0x0066CCFF,0x006699FF,0x006666FF,0x006633FF,0x006600FF,0x0033FFFF,0x0033CCFF,0x003399FF,
        0x003366FF,0x003333FF,0x003300FF,0x0000FFFF,0x0000CCFF,0x000099FF,0x000066FF,0x000033FF,0xEE0000FF,
        0xDD0000FF,0xBB0000FF,0xAA0000FF,0x880000FF,0x770000FF,0x550000FF,0x440000FF,0x220000FF,0x110000FF,
        0x00EE00FF,0x00DD00FF,0x00BB00FF,0x00AA00FF,0x008800FF,0x007700FF,0x005500FF,0x004400FF,0x002200FF,
        0x001100FF,0x0000EEFF,0x0000DDFF,0x0000BBFF,0x0000AAFF,0x000088FF,0x000077FF,0x000055FF,0x000044FF,
        0x000022FF,0x000011FF,0xEEEEEEFF,0xDDDDDDFF,0xBBBBBBFF,0xAAAAAAFF,0x888888FF,0x777777FF,0x555555FF,
        0x444444FF,0x222222FF,0x111111FF,0x000000FF
    ]
    
    var sizex:CInt = 0, sizey:CInt = 0, sizez:CInt = 0

    var numVoxels:CInt = 0
    var voxels:[MV_Voxel]? = nil

    var isCustomPalette = false
    var palette:[MV_RGBA] = [MV_RGBA](repeating: MV_RGBA(), count: 256)

    var version:CInt = 0
    
    struct chunk_t {
        var ch_id:CInt = 0
        var contentSize:CInt = 0
        var childrenSize:CInt = 0
        var end:CLong = 0
    }
    
    func MV_ID( _ a:CInt, _ b:CInt, _ c:CInt, _ d:CInt ) -> CInt {
        return ( a ) | ( b << 8 ) | ( c << 16 ) | ( d << 24 )
    }
    
    func Free() {
        
        if voxels != nil {
            voxels?.removeAll()
            voxels = nil
        }
        
        numVoxels = 0;
        
        sizex = 0
        sizey = 0
        sizez = 0
        
        isCustomPalette = false
        
        version = 0
    }
    
    deinit {
        Free()
    }
    
    func LoadModel(path: String) -> Bool {
        
        Free()
        
        guard let fp = fopen(path, "rb") else {
            print("Failed to open file")
            return false
        }

        let success = ReadModelFile(fp)
        fclose(fp)
        
        if success == false {
            Free()
        }
        
        return success
    }
    
    func ReadModelFile(_ fp:UnsafeMutablePointer<FILE>) -> Bool {
        
        let MV_VERSION:CInt = 150
        
        let ID_VOX:CInt  = MV_ID("V".toCInt(), "O".toCInt(), "X".toCInt(), " ".toCInt())
        let ID_MAIN:CInt = MV_ID("M".toCInt(), "A".toCInt(), "I".toCInt(), "N".toCInt())
        let ID_SIZE:CInt = MV_ID("S".toCInt(), "I".toCInt(), "Z".toCInt(), "E".toCInt())
        let ID_XYZI:CInt = MV_ID("X".toCInt(), "Y".toCInt(), "Z".toCInt(), "I".toCInt())
        let ID_RGBA:CInt = MV_ID("R".toCInt(), "G".toCInt(), "B".toCInt(), "A".toCInt())
        
        // magic number
        let magic = ReadInt(fp)
        if magic != ID_VOX {
            print("magic number does not match")
            return false
        }

        // version
        version = ReadInt(fp)
        if version != MV_VERSION {
            print("version does not match")
            return false
        }
        
        // main chunk
        var mainChunk:chunk_t = chunk_t()
        ReadChunk(fp, &mainChunk)
        if mainChunk.ch_id != ID_MAIN {
            print("main chunk is not found")
            return false
        }
        
        // skip content of main chunk
        fseek(fp, Int(mainChunk.contentSize), SEEK_CUR)
        
        // read children chunks
        while ftell(fp) < mainChunk.end {
            // read chunk header
            var sub:chunk_t = chunk_t()
            ReadChunk(fp, &sub)
            
            if sub.ch_id == ID_SIZE {
                // size
                sizex = ReadInt(fp)
                sizey = ReadInt(fp)
                sizez = ReadInt(fp)
            }
            else if sub.ch_id == ID_XYZI {
                // numVoxels
                numVoxels = ReadInt(fp)
                if numVoxels < 0 {
                    print("negative number of voxels");
                    return false
                }
                
                // voxels
                if numVoxels > 0 {
                    voxels = [MV_Voxel](repeating: MV_Voxel(), count: Int(numVoxels))
                    fread(UnsafeMutablePointer(mutating: voxels), MemoryLayout<MV_Voxel>.size, Int(numVoxels), fp)
                }
            }
            else if sub.ch_id == ID_RGBA {
                // last color is not used, so we only need to read 255 colors
                isCustomPalette = true
                fread(UnsafeMutablePointer(mutating: palette).advanced(by: 1), MemoryLayout<MV_RGBA>.size, 255, fp)
                
                // NOTICE : skip the last reserved color
                var reserved = UnsafeMutablePointer<MV_Voxel>.allocate(capacity: 1)
                fread(&reserved, MemoryLayout< MV_RGBA >.size, 1, fp)
            }
            
            fseek(fp, sub.end, SEEK_SET)
        }
        
        // print model info
        print("[Log] MV_VoxelModel :: Model : \(sizex) \(sizey) \(sizez) : \(numVoxels)")
        
        return true
    }
    
    func ReadInt(_ fp:UnsafeMutablePointer<FILE>) -> CInt {
        var v:CInt = 0
        fread( &v, 4, 1, fp )
        return v
    }
    
    func ReadChunk(_ fp:UnsafeMutablePointer<FILE>, _ chunk:inout chunk_t) {
        // read chunk
        chunk.ch_id = ReadInt(fp)
        chunk.contentSize  = ReadInt(fp)
        chunk.childrenSize = ReadInt(fp)
        
        // end of chunk : used for skipping the whole chunk
        chunk.end = ftell(fp) + CLong(chunk.contentSize + chunk.childrenSize)
        
        // print chunk info
        if let chunk_id = chunk.ch_id.chunkIDToString() {
            print("[Log] MV_VoxelModel :: Chunk : \(chunk_id) \(chunk.contentSize) \(chunk.childrenSize)")
        }
    }
}

extension CInt {
    func chunkIDToString() -> String? {
        let a = self & 0xFF
        let b = (self >> 8) & 0xFF
        let c = (self >> 16) & 0xFF
        let d = (self >> 24) & 0xFF
        
        guard let usa = UnicodeScalar(Int(a)),
            let usb = UnicodeScalar(Int(b)),
            let usc = UnicodeScalar(Int(c)),
            let usd = UnicodeScalar(Int(d)) else {
            
            return nil
        }

        return String(usa) + String(usb) + String(usc) + String(usd)
    }
}

extension String {
    func toCInt() -> CInt {
        return CInt(UnicodeScalar(self)!.value)
    }
}
