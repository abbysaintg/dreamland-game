import { useState, useEffect, useRef } from "react"

function Game() {
    const [outputs, setOutputs] = useState([])
    const [text, setText] = useState("")
    const inputRef = useRef(null)

    const handleKeyDown = (e) => {
        if (e.key === "Enter") {
            setOutputs([...outputs, text])
            setText("")
            inputRef.current.focus()
        }
    }

    return (
        <div className='game-container'>
            <div className='outputs-container'>
                {outputs.map((output) => (
                    <div key={output} className='output'>
                        {output}
                    </div>
                ))}
            </div>
            <input className='inputs-container' type='text' value={text} onChange={(e) => setText(e.target.value)} onKeyDown={handleKeyDown} />
        </div>
    )
}

export default Game
