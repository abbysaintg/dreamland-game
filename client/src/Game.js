import { useState, useEffect, useRef } from "react"

function Game() {
    const [responses, setResponses] = useState([])
    const [input, setInput] = useState("")
    const inputRef = useRef(null)
    const containerRef = useRef(null)
    const bottomRef = useRef(null)

    // FETCH OUTPUTS
    useEffect(() => {
        fetch("/responses")
            .then((r) => r.json())
            .then((data) => setResponses(data))
    }, [])

    // SUBMIT USER INPUT
    const handleKeyDown = (e) => {
        if (e.key === "Enter") {
            if (input === "reset") {
                fetch(`/responses/${responses[responses.length - 1].id}`, {
                    method: "DELETE",
                })
                    .then((response) => {
                        if (!response.ok) {
                            throw new Error(`Failed to delete response, status code: ${response.status}`)
                        }
                        return response
                    })
                    .then(() => {
                        setResponses([responses[0], responses[1]])
                        setInput("")
                        inputRef.current.focus()
                    })
                    .catch((error) => {
                        console.error(error)
                    })
            } else {
                fetch("/responses", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                    },
                    body: JSON.stringify({ input }),
                })
                    .then((response) => response.json())
                    .then((data) => {
                        setResponses([...responses, data])
                        setInput("")
                        inputRef.current.focus()
                    })
                    .catch((error) => console.error("Error:", error))
            }
        }
    }

    useEffect(() => {
        if (bottomRef.current) {
            bottomRef.current.scrollIntoView({ behavior: "smooth" })
        }
    }, [responses])

    // REMOVE PLACEHOLDER TEXT
    const handleFocus = (event) => {
        event.target.placeholder = ""
    }

    // ADD PLACEHOLDER TEXT
    const handleBlur = (event) => {
        event.target.placeholder = "type something..."
    }

    return (
        <div className='game-container'>
            <div className='outputs-container' ref={containerRef}>
                {responses.map((response) => (
                    <div key={response.id} className='output' ref={response.id === responses[responses.length - 1].id ? bottomRef : null}>
                        {response.output}
                    </div>
                ))}
            </div>
            <input className='inputs-container' type='text' placeholder='type something...' value={input} onChange={(e) => setInput(e.target.value)} onKeyDown={handleKeyDown} onFocus={handleFocus} onBlur={handleBlur} ref={inputRef} />
        </div>
    )
}

export default Game
