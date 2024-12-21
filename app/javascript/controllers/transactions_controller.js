import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="transactions"
export default class extends Controller {
  static values = {
    address: String // TON address
  }

  connect() {
    console.log("TON Transactions controller connected!")
    this.lastSeenTransactionId = null
    this.pollingInterval = setInterval(() => this.fetchTransactions(), 5000)
  }

  disconnect() {
    console.log("TON Transactions controller disconnected!")
    clearInterval(this.pollingInterval)
  }

  async fetchTransactions() {
    const apiUrl = `https://toncenter.com/api/v2/getTransactions?address=${this.addressValue}`
    try {
      const response = await fetch(apiUrl)
      if (!response.ok) throw new Error("Failed to fetch transactions")

      const data = await response.json()
      if (data.result && data.result.length > 0) {
        this.processTransactions(data.result)
      }
    } catch (error) {
      console.error("Error fetching TON transactions:", error)
    }
  }

  processTransactions(transactions) {
    const newTransactions = []

    // Check for new transactions since the last seen transaction
    for (const transaction of transactions) {
      if (!this.lastSeenTransactionId || transaction.transaction_id.hash !== this.lastSeenTransactionId) {
        newTransactions.push(transaction)
      } else {
        break // Stop when we reach a transaction we've already seen
      }
    }

    if (newTransactions.length > 0) {
      // Update the last seen transaction ID
      this.lastSeenTransactionId = newTransactions[0].transaction_id.hash

      // Update the UI
      this.updateTransactionList(newTransactions)
    }
  }

  updateTransactionList(transactions) {
    const transactionList = document.getElementById("transaction-list")

    transactions.reverse().forEach(transaction => {
      const div = document.createElement("div")
      div.textContent = `Transaction: ${transaction.transaction_id.hash}, Amount: ${transaction.in_msg.value || 0} TON`
      transactionList.prepend(div) // Add new transactions to the top of the list
    })
  }
}
