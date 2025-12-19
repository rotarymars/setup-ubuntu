#!/usr/bin/env node

const path = require('path');
const fs = require('fs');
const os = require('os');

// Read JSON from stdin
let input = '';
process.stdin.on('data', chunk => input += chunk);
process.stdin.on('end', () => {
  try {
    const data = JSON.parse(input);

    // DEBUG: Write raw data to file for inspection
    const debugFile = path.join(os.homedir(), '.claude', 'statusline-debug.json');
    try {
      fs.writeFileSync(debugFile, JSON.stringify(data, null, 2));
    } catch (e) {
      // Ignore debug write errors
    }

    // Extract values
    const model = data.model?.display_name || 'Unknown';
    const currentDir = path.basename(data.workspace?.current_dir || data.cwd || '.');

    // Get context window data (from the API response)
    const contextWindow = data.context_window || {};
    const contextSize = contextWindow.context_window_size || 200000;

    // Calculate total tokens (these represent current context usage)
    const totalInputTokens = contextWindow.total_input_tokens || 0;
    const totalOutputTokens = contextWindow.total_output_tokens || 0;
    const totalTokens = totalInputTokens + totalOutputTokens;

    // Calculate percentage of context window used
    const percentage = Math.min(100, Math.round((totalTokens / contextSize) * 100));

    // Get cost information
    const cost = data.cost?.total_cost_usd || 0;
    const costDisplay = cost > 0 ? `$${cost.toFixed(3)}` : '$0.00';

    // Format token display
    const tokenDisplay = formatTokenCount(totalTokens);
    const contextSizeDisplay = formatTokenCount(contextSize);

    // Color coding for percentage
    let percentageColor = '\x1b[32m'; // Green
    if (percentage >= 70) percentageColor = '\x1b[33m'; // Yellow
    if (percentage >= 90) percentageColor = '\x1b[31m'; // Red

    // Build status line with tokens, context usage percentage, and cost
    const statusLine = `[${model}] 📁 ${currentDir} | 🪙 ${tokenDisplay}/${contextSizeDisplay} ${percentageColor}${percentage}%\x1b[0m | 💰 ${costDisplay}`;

    console.log(statusLine);
  } catch (error) {
    // Fallback status line on error
    console.log('[Error] 📁 . | 🪙 0 | 0%');
  }
});

function formatTokenCount(tokens) {
  if (tokens >= 1000000) {
    return `${(tokens / 1000000).toFixed(1)}M`;
  } else if (tokens >= 1000) {
    return `${(tokens / 1000).toFixed(1)}K`;
  }
  return tokens.toString();
}
