import React from 'react'
import { useParams } from "react-router-dom";

const Foods = () => {
  const { restaurantsId } = useParams()

  return (
    <>
      フード一覧
      <p>restaurantsIdは{restaurantsId}です</p>
    </>
  )
}

export default Foods
