using NguyenVietQuang_2380601811_23DTHE1.DTOs;

namespace NguyenVietQuang_2380601811_23DTHE1.Services
{
    public interface IVideoCallService
    {
        Task<VideoCallRoomDto> CreateRoomAsync(string roomName, int maxParticipants = 10);
        Task<VideoCallTokenDto> GenerateTokenAsync(string roomName, string participantName, int userId);
        Task<VideoCallRoomDto?> GetRoomInfoAsync(string roomName);
        Task<List<ParticipantDto>> GetParticipantsAsync(string roomName);
        Task<bool> EndRoomAsync(string roomName);
    }
}
