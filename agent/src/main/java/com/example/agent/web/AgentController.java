package com.example.agent.web;

import com.example.agent.service.AgentService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class AgentController {

  private final AgentService agentService;

  public AgentController(AgentService agentService) {
    this.agentService = agentService;
  }

  @PostMapping(value = "/run", consumes = "application/json")
  public String run(@RequestBody java.util.Map<String, String> payload) {
    return agentService.run(payload.getOrDefault("prompt", ""));
  }
}
