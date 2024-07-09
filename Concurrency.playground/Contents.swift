import Foundation

// Simulated API call function
func simulatedAPICall(taskName: String, delay: UInt32, completion: @escaping () -> Void) {
    DispatchQueue.global().async {
        print("\(taskName) started")
        sleep(delay)
        print("\(taskName) completed")
        completion()
    }
}

// Example using DispatchWorkItem, DispatchGroup, and Task
func exampleWithMultipleAPICalls() {
    let dispatchGroup = DispatchGroup()
    
    // Define DispatchWorkItems
    let workItem1 = DispatchWorkItem {
        simulatedAPICall(taskName: "API Call 1", delay: 2) {
            dispatchGroup.leave()
        }
    }
    
    let workItem2 = DispatchWorkItem {
        simulatedAPICall(taskName: "API Call 2", delay: 1) {
            dispatchGroup.leave()
        }
    }
    
    let workItem3 = DispatchWorkItem {
        simulatedAPICall(taskName: "API Call 3", delay: 3) {
            dispatchGroup.leave()
        }
    }
    
    // Enter the group before starting the work items
    dispatchGroup.enter()
    DispatchQueue.global().async(execute: workItem1)
    
    dispatchGroup.enter()
    DispatchQueue.global().async(execute: workItem2)
    
    dispatchGroup.enter()
    DispatchQueue.global().async(execute: workItem3)
    
    // Notify when all tasks are completed
    dispatchGroup.notify(queue: .main) {
        print("All API calls completed. Processing data...")
        // Simulate data processing
        Task {
            await processData()
            print("Data processing completed")
        }
    }
}

// Function to simulate data processing
func processData() async {
    print("Data processing started")
    try? await Task.sleep(nanoseconds: 2 * 1_000_000_000) // 2 seconds
    print("Data processing completed")
}

// Run the example
exampleWithMultipleAPICalls()
