import UIKit
import PDFKit

class PDFGenerator {
    /// UIImage를 PDF Data로 변환
    static func createPDFData(from image: UIImage) -> Data? {
        print("PDFGenerator: PDF 데이터 생성 시작")
        print("PDFGenerator: 이미지 크기 - \(image.size)")
        
        let pdfMetaData = [
            kCGPDFContextCreator: "Camer4pdf",
            kCGPDFContextAuthor: "Camera App"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        // 이미지 크기에 맞는 PDF 페이지 크기 설정
        let pageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { context in
            context.beginPage()
            image.draw(in: pageRect)
        }
        
        print("PDFGenerator: PDF 데이터 생성 성공 - \(data.count) bytes")
        return data
    }
    
    /// UIImage를 PDF로 변환
    static func createPDF(from image: UIImage) -> URL? {
        print("PDFGenerator: PDF 생성 시작")
        print("PDFGenerator: 이미지 크기 - \(image.size)")
        
        let pdfMetaData = [
            kCGPDFContextCreator: "Camer4pdf",
            kCGPDFContextAuthor: "Camera App"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        // 이미지 크기에 맞는 PDF 페이지 크기 설정
        let pageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        // 임시 디렉토리에 PDF 파일 저장
        let fileName = "Photo_\(Date().timeIntervalSince1970).pdf"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        print("PDFGenerator: PDF 저장 경로 - \(url.path)")
        
        do {
            try renderer.writePDF(to: url) { context in
                context.beginPage()
                image.draw(in: pageRect)
            }
            
            // 파일이 실제로 생성되었는지 확인
            if FileManager.default.fileExists(atPath: url.path) {
                print("PDFGenerator: PDF 파일 생성 성공")
                return url
            } else {
                print("PDFGenerator: PDF 파일이 생성되지 않음")
                return nil
            }
        } catch {
            print("PDFGenerator: PDF 생성 실패 - \(error.localizedDescription)")
            return nil
        }
    }
    
    /// 여러 이미지를 하나의 PDF로 변환
    static func createPDF(from images: [UIImage]) -> URL? {
        guard !images.isEmpty else { return nil }
        
        let pdfMetaData = [
            kCGPDFContextCreator: "Camer4pdf",
            kCGPDFContextAuthor: "Camera App"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        // A4 크기로 설정
        let pageRect = CGRect(x: 0, y: 0, width: 595, height: 842) // A4 size in points
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let fileName = "Photos_\(Date().timeIntervalSince1970).pdf"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try renderer.writePDF(to: url) { context in
                for image in images {
                    context.beginPage()
                    
                    // 이미지를 페이지에 맞게 스케일링
                    let imageRect = fitImageInRect(imageSize: image.size, rect: pageRect)
                    image.draw(in: imageRect)
                }
            }
            return url
        } catch {
            print("PDF 생성 실패: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// 이미지를 지정된 사각형 안에 맞춤
    private static func fitImageInRect(imageSize: CGSize, rect: CGRect) -> CGRect {
        let imageAspect = imageSize.width / imageSize.height
        let rectAspect = rect.width / rect.height
        
        var scaledRect = rect
        
        if imageAspect > rectAspect {
            // 이미지가 더 넓음
            scaledRect.size.height = rect.width / imageAspect
            scaledRect.origin.y = (rect.height - scaledRect.height) / 2
        } else {
            // 이미지가 더 높음
            scaledRect.size.width = rect.height * imageAspect
            scaledRect.origin.x = (rect.width - scaledRect.width) / 2
        }
        
        return scaledRect
    }
}

