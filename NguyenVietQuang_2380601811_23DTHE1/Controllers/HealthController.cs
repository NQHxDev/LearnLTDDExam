using Microsoft.AspNetCore.Mvc;

namespace NguyenVietQuang_2380601811_23DTHE1.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class HealthController : ControllerBase
    {
        [HttpGet]
        public IActionResult Get()
        {
            return Ok(new { 
                status = "healthy", 
                message = "API is running",
                timestamp = DateTime.UtcNow 
            });
        }
    }
}
