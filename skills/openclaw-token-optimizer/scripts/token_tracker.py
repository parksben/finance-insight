#!/usr/bin/env python3
"""
Token usage tracker with budget alerts.
Monitors API usage and warns when approaching limits.
"""
import json
import os
from datetime import datetime, timedelta
from pathlib import Path

STATE_FILE = Path.home() / ".openclaw/workspace/memory/token-tracker-state.json"

def load_state():
    """Load tracking state from file."""
    if STATE_FILE.exists():
        with open(STATE_FILE, 'r') as f:
            return json.load(f)
    return {
        "daily_usage": {},
        "alerts_sent": [],
        "last_reset": datetime.now().isoformat()
    }

def save_state(state):
    """Save tracking state to file."""
    STATE_FILE.parent.mkdir(parents=True, exist_ok=True)
    with open(STATE_FILE, 'w') as f:
        json.dump(state, f, indent=2)

def get_usage_from_session_status():
    """Parse session status to extract token usage.
    Returns dict with input_tokens, output_tokens, and cost.
    Excludes free models from cost calculation.
    """
    # This would integrate with OpenClaw's session_status tool
    # For now, returns placeholder structure
    # Free models (starting with ac2api/) are excluded from cost calculation
    return {
        "input_tokens": 0,
        "output_tokens": 0,
        "total_cost": 0.0,
        "model": "anthropic/claude-sonnet-4-5"
    }


def is_free_model(model_name):
    """Check if model is free and should be excluded from cost calculation.
    
    Args:
        model_name: Full model identifier (e.g. 'ac2api-qwen/qwen3-coder-plus')
    
    Returns:
        bool: True if model is free, False otherwise
    """
    # Models starting with 'ac2api-' are free (AIClient2API)
    # Other potential free model prefixes can be added here
    free_prefixes = [
        'ac2api-',  # AIClient2API free models
        'openrouter/free-',  # Example for future expansion
        'local/',  # Example for local models
    ]
    
    for prefix in free_prefixes:
        if model_name.startswith(prefix):
            return True
    return False


def calculate_cost(input_tokens, output_tokens, model_name, cost_per_million_input=None, cost_per_million_output=None):
    """Calculate cost excluding free models.
    
    Args:
        input_tokens: Number of input tokens
        output_tokens: Number of output tokens
        model_name: Model identifier
        cost_per_million_input: Cost per million input tokens (default from known models)
        cost_per_million_output: Cost per million output tokens (default from known models)
    
    Returns:
        float: Calculated cost in USD, or 0.0 for free models
    """
    if is_free_model(model_name):
        return 0.0  # Free models have zero cost
    
    # Cost per 1M tokens (input/output average) - for paid models only
    default_costs = {
        "github-copilot/claude-opus-4.6": (15.0, 15.0),  # input, output
        "github-copilot/claude-sonnet-4.6": (3.0, 3.0),
        "github-copilot/claude-haiku-4.5": (0.25, 0.25),
        "github-copilot/gpt-5-mini": (0.15, 0.15),
        "anthropic/claude-opus-4": (15.0, 15.0),
        "anthropic/claude-sonnet-4-5": (3.0, 3.0),
        "anthropic/claude-haiku-4": (0.25, 0.25),
        "openai/gpt-4o": (2.5, 10.0),
        "openai/gpt-4o-mini": (0.15, 0.6),
    }
    
    if cost_per_million_input is None or cost_per_million_output is None:
        input_cost, output_cost = default_costs.get(model_name, (0.0, 0.0))
    else:
        input_cost = cost_per_million_input
        output_cost = cost_per_million_output
    
    input_cost_total = (input_tokens / 1_000_000) * input_cost
    output_cost_total = (output_tokens / 1_000_000) * output_cost
    
    return input_cost_total + output_cost_total

def check_budget(daily_limit_usd=5.0, warn_threshold=0.8):
    """Check if usage is approaching daily budget.
    Only counts paid models toward budget, excludes free models.
    
    Args:
        daily_limit_usd: Daily spending limit in USD
        warn_threshold: Fraction of limit to trigger warning (default 80%)
    
    Returns:
        dict with status, usage, limit, and alert message if applicable
    """
    state = load_state()
    today = datetime.now().date().isoformat()
    
    # Reset if new day
    if today not in state["daily_usage"]:
        state["daily_usage"] = {today: {"cost": 0.0, "tokens": 0, "paid_tokens": 0}}
        state["alerts_sent"] = []
    
    usage = state["daily_usage"][today]
    percent_used = (usage["cost"] / daily_limit_usd) * 100
    
    result = {
        "date": today,
        "cost": usage["cost"],  # Only paid model cost
        "tokens": usage["tokens"],  # Total tokens (including free)
        "paid_tokens": usage["paid_tokens"],  # Paid model tokens only
        "limit": daily_limit_usd,
        "percent_used": percent_used,
        "status": "ok"
    }
    
    # Check thresholds
    if percent_used >= 100:
        result["status"] = "exceeded"
        result["alert"] = f"⚠️ Daily budget exceeded! ${usage['cost']:.2f} / ${daily_limit_usd:.2f} (paid models only)"
    elif percent_used >= (warn_threshold * 100):
        result["status"] = "warning"
        result["alert"] = f"⚠️ Approaching daily limit: ${usage['cost']:.2f} / ${daily_limit_usd:.2f} ({percent_used:.0f}% of paid models only)"
    
    return result

def suggest_cheaper_model(current_model, task_type="general"):
    """Suggest cheaper alternative models based on task type.
    
    Args:
        current_model: Currently configured model
        task_type: Type of task (general, simple, complex)
    
    Returns:
        dict with suggestion and cost savings
    """
    # Cost per 1M tokens (input/output average)
    model_costs = {
        "anthropic/claude-opus-4": 15.0,
        "anthropic/claude-sonnet-4-5": 3.0,
        "anthropic/claude-haiku-4": 0.25,
        "google/gemini-2.0-flash-exp": 0.075,
        "openai/gpt-4o": 2.5,
        "openai/gpt-4o-mini": 0.15
    }
    
    suggestions = {
        "simple": [
            ("anthropic/claude-haiku-4", "12x cheaper, great for file reads, routine checks"),
            ("google/gemini-2.0-flash-exp", "40x cheaper via OpenRouter, good for simple tasks")
        ],
        "general": [
            ("anthropic/claude-sonnet-4-5", "Balanced performance and cost"),
            ("google/gemini-2.0-flash-exp", "Much cheaper, decent quality")
        ],
        "complex": [
            ("anthropic/claude-opus-4", "Best reasoning, use sparingly"),
            ("anthropic/claude-sonnet-4-5", "Good balance for most complex tasks")
        ]
    }
    
    return {
        "current": current_model,
        "current_cost": model_costs.get(current_model, "unknown"),
        "suggestions": suggestions.get(task_type, suggestions["general"])
    }

def main():
    """CLI interface for token tracker."""
    import sys
    
    if len(sys.argv) < 2:
        print("Usage: token_tracker.py [check|suggest|reset|calculate-cost]")
        sys.exit(1)
    
    command = sys.argv[1]
    
    if command == "check":
        result = check_budget()
        print(json.dumps(result, indent=2))
    
    elif command == "suggest":
        task = sys.argv[2] if len(sys.argv) > 2 else "general"
        current = sys.argv[3] if len(sys.argv) > 3 else "anthropic/claude-sonnet-4-5"
        result = suggest_cheaper_model(current, task)
        print(json.dumps(result, indent=2))
    
    elif command == "reset":
        state = load_state()
        state["daily_usage"] = {}
        state["alerts_sent"] = []
        save_state(state)
        print("Token tracker state reset.")
    
    elif command == "calculate-cost":
        # Calculate cost for specific usage, excluding free models
        if len(sys.argv) < 5:
            print("Usage: token_tracker.py calculate-cost <input_tokens> <output_tokens> <model_name>")
            sys.exit(1)
        
        input_tokens = int(sys.argv[2])
        output_tokens = int(sys.argv[3])
        model_name = sys.argv[4]
        
        cost = calculate_cost(input_tokens, output_tokens, model_name)
        is_free = is_free_model(model_name)
        
        result = {
            "model": model_name,
            "input_tokens": input_tokens,
            "output_tokens": output_tokens,
            "total_tokens": input_tokens + output_tokens,
            "is_free_model": is_free,
            "calculated_cost": cost,
            "message": "Model is free (no cost)" if is_free else f"Cost calculated: ${cost:.4f}"
        }
        
        print(json.dumps(result, indent=2))
    
    else:
        print(f"Unknown command: {command}")
        sys.exit(1)

if __name__ == "__main__":
    main()
