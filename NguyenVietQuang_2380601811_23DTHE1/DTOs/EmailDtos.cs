namespace NguyenVietQuang_2380601811_23DTHE1.DTOs
{
    public class SendEmailDto
    {
        public string ToEmail { get; set; } = string.Empty;
        public string Subject { get; set; } = string.Empty;
        public string Body { get; set; } = string.Empty;
    }

    public class EmailResponseDto
    {
        public bool Success { get; set; }
        public string Message { get; set; } = string.Empty;
        public string? EmailId { get; set; }
    }
}
