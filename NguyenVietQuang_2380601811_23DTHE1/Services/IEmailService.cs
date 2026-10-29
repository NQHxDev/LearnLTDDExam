using NguyenVietQuang_2380601811_23DTHE1.DTOs;

namespace NguyenVietQuang_2380601811_23DTHE1.Services
{
    public interface IEmailService
    {
        Task<bool> SendWelcomeEmailAsync(string toEmail, string userName);
        Task<bool> SendOrderConfirmationAsync(string toEmail, OrderDto order);
        Task<bool> SendShippingNotificationAsync(string toEmail, OrderDto order);
        Task<bool> SendPasswordResetEmailAsync(string toEmail, string resetToken);
        Task<bool> SendEmailAsync(string toEmail, string subject, string htmlBody);
    }
}
