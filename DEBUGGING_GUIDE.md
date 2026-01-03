# Debugging Guide for GolfShotTracker

## Issue: Blank Screen After Starting Round

### How to Debug:

1. **Check Xcode Console Logs**
   - Run the app in Xcode
   - Look for these log prefixes:
     - 🔵 = Round creation
     - 🟢 = ViewModel operations
     - 🟣 = View lifecycle
     - 🟠 = User actions
     - ❌ = Errors

2. **Expected Log Flow:**
   ```
   🟠 Begin Round button tapped
   🔵 Creating round: [CourseName], holes: [9 or 18]
   🔵 Round inserted into context
   🔵 Created hole 1
   🔵 Created hole 2
   ... (for each hole)
   🔵 Set [N] holes on round
   🔵 Round saved successfully
   🔵 Round has [N] holes after save
   🟠 Round created, calling onRoundCreated
   🟠 onRoundCreated callback - Round: [CourseName], Holes: [N]
   🟠 Setting showHoleTracker = true
   🟣 HoleTrackerView init - Round: [CourseName]
   🟢 HoleTrackerViewModel init - Round: [CourseName], Holes count: [N]
   🟢 Round holes array count: [N]
   🟢 loadHole() called for hole 1
   🟢 Round has [N] holes in array
   🟢 Found hole 1: par=4
   🟣 HoleTrackerView onAppear
   🟣 Current hole: exists
   ```

3. **Common Issues to Check:**

   **Issue A: Holes array is empty (0)**
   - If you see "Round holes array count: 0"
   - This means SwiftData relationship isn't loading
   - **Fix**: The round needs to be refreshed from context

   **Issue B: Hole not found**
   - If you see "Hole 1 not found, creating..."
   - The hole creation fallback is working
   - But this shouldn't happen if round was created correctly

   **Issue C: View not appearing**
   - If you don't see "🟣 HoleTrackerView onAppear"
   - The fullScreenCover might not be presenting
   - Check if `showHoleTracker` is actually true

   **Issue D: Round is nil**
   - If you see "Error: Round not found"
   - The `createdRound` state is nil
   - Check the callback chain

4. **Quick Fixes to Try:**

   **Fix 1: Refresh round from context**
   - After creating round, fetch it again from context
   - This ensures relationships are loaded

   **Fix 2: Use NavigationStack instead of fullScreenCover**
   - fullScreenCover might have context issues
   - Try using NavigationLink or navigationDestination

   **Fix 3: Ensure modelContext is available**
   - Check that HoleTrackerView has @Environment(\.modelContext)
   - This is already added in the code

5. **Check Round Details:**
   - After the blank screen, go to Home tab
   - Check if the round appears in the list
   - If it shows "Total: 0", the round was created but no holes were tracked
   - This confirms the view never loaded properly

### Next Steps:
1. Run the app and check console logs
2. Share the log output to identify where it's failing
3. Check if the round appears in the list after the blank screen

