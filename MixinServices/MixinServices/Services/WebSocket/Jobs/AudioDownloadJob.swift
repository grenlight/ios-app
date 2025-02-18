import Foundation

public class AudioDownloadJob: AttachmentDownloadJob {
    
    override var fileUrl: URL {
        return AttachmentContainer.url(for: .audios, filename: fileName)
    }
    
    override public class func jobId(messageId: String) -> String {
        return "audio-download-\(messageId)"
    }
    
    override public func getJobId() -> String {
        return FileDownloadJob.jobId(messageId: messageId)
    }
    
}
